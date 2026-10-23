#!/bin/bash
set -e

RESOURCE_GROUP="rg-owncloud-dac"
LOCATION="austriaeast"
ENVIRONMENT_NAME="cae-owncloud-dac"
CONTAINER_APP_NAME="ca-owncloud"
CUSTOM_DOMAIN="oc.botzheim.eu"

echo "=== 1. Erőforrás-csoport ellenőrzése / létrehozása ==="
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "=== 2. Container Apps környezet létrehozása ==="
az containerapp env create \
  --name $ENVIRONMENT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

echo "=== 3. OwnCloud Container App deploy-olása környezeti változókkal ==="
az containerapp create \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $ENVIRONMENT_NAME \
  --image owncloud/server:latest \
  --target-port 8080 \
  --ingress external \
  --cpu 1.0 \
  --memory 2.0 \
  --env-vars \
    OWNCLOUD_DOMAIN=$CUSTOM_DOMAIN \
    OWNCLOUD_TRUSTED_DOMAINS=$CUSTOM_DOMAIN \
    OWNCLOUD_ADMIN_USERNAME=ocadmin \
    OWNCLOUD_DB_TYPE=pgsql \
    OWNCLOUD_DB_HOST="psql-owncloud-dac.postgres.database.azure.com" \
    OWNCLOUD_DB_NAME="owncloud" \
    OWNCLOUD_DB_USERNAME="psqladmin" \
    OWNCLOUD_DB_PASSWORD="NewSecurePassword123!"

echo "=== 4. Egyedi domain és CNAME-alapú SSL tanúsítvány kötése ==="
az containerapp hostname bind \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --hostname $CUSTOM_DOMAIN \
  --environment $ENVIRONMENT_NAME \
  --validation-method CNAME

echo "=== Művelet sikeres! Az ownCloud elérhető itt: https://$CUSTOM_DOMAIN ==="
