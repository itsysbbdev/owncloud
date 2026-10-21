# ADR-002: Azure DevOps CI/CD Pipeline és Terraform State Backend

## Status
Elfogadva

## Context
Az ownCloud infrastruktúra (DaC) életciklus-kezeléséhez távoli Terraform állapotfájl-tárolóra (Azure Blob Storage) és automatizált CI/CD pipeline-ra (Azure DevOps + GitHub integráció) van szükség.

## Decision
- **Terraform Backend:** Az `austriaeast` régióban a `rg-terraform-state` erőforráscsoportban Storage Account (`sttfstate...`) és `tfstate` konténer tárolja a `dev.terraform.tfstate` fájlt.
- **Infrastruktúra (IaC):** Azure Container Apps (ACA), PostgreSQL Flexible Server (`B_Standard_B1ms`) és Azure Files.
- **CI/CD Automatizálás:** A `main` ágra történő push után a pipeline automatikusan futtatja a `terraform plan`-t és a `terraform apply`-t.
