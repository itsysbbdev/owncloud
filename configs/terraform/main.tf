terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-owncloud-dac"
  location = "austriaeast"
}

# --- 1. Perzisztens Tároló (Azure Files) ---
resource "azurerm_storage_account" "st" {
  name                     = "stownclouddac${substr(azurerm_resource_group.rg.id, -6, 6)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "share" {
  name                 = "owncloud-data"
  storage_account_name = azurerm_storage_account.st.name
  quota                = 50
}

# --- 2. Adatbázis (PostgreSQL Flexible Server - B_Standard_B1ms) ---
resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = "psql-owncloud-dac"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "14"
  administrator_login    = "psqladmin"
  administrator_password = random_password.db_password.result
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "owncloud"
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = "utf8"
  collation = "en_US.utf8"
}

# --- 3. Container Apps Environment & Application ---
resource "azurerm_container_app_environment" "env" {
  name                = "cae-owncloud-dac"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "app" {
  name                         = "ca-owncloud"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "owncloud"
      image  = "owncloud/server:latest"
      cpu    = "1.0"
      memory = "2.0Gi"

      env {
        name  = "OWNCLOUD_DOMAIN"
        value = "localhost"
      }
      env {
        name  = "OWNCLOUD_DB_TYPE"
        value = "pgsql"
      }
      env {
        name  = "OWNCLOUD_DB_HOST"
        value = azurerm_postgresql_flexible_server.pg.fqdn
      }
      env {
        name  = "OWNCLOUD_DB_NAME"
        value = azurerm_postgresql_flexible_server_database.db.name
      }
      env {
        name  = "OWNCLOUD_DB_USERNAME"
        value = "psqladmin"
      }
      env {
        name  = "OWNCLOUD_DB_PASSWORD"
        value = random_password.db_password.result
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
