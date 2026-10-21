# ADR-002: Azure DevOps CI/CD Pipeline és Terraform State Backend

## Status
Elfogadva

## Context
Az ownCloud infrastruktúra (DaC) életciklus-kezeléséhez távoli Terraform állapotfájl-tárolóra (Azure Blob Storage) és automatizált CI/CD pipeline-ra (Azure DevOps + GitHub integráció) van szükség, amelyet teljes egészében kódból (CLI scripttel) hozunk létre.

## Decision
- **Terraform Backend:** Az `austriaeast` régióban a `rg-terraform-state` erőforráscsoportban véletlenszerű nevű (`sttfstate...`) Storage Account és `tfstate` konténer jön létre, amelyhez a `configs/terraform/backend.tf` automatikusan generálódik (`dev.terraform.tfstate`).
- **Verziókezelés:** GitHub (`itsysbbdev/owncloud-azure-dac`).
- **CI/CD Orchestration:** Azure DevOps (`ownCloud-DaC-Project` projekt, `owncloud-dac-pipeline` pipeline).
- **Bootstrapping:** A `scripts/azure-init.sh` script idempotens módon felépíti a backendet, a DevOps projektet, a GitHub Service Connectiont és a pipeline-t.

## Használat
1. Azure CLI bejelentkezés a DevContainerben: `az login --use-device-code`
2. Azure DevOps szervezet URL megadása: `export AZURE_DEVOPS_EXT_ORG_URL="https://dev.azure.com/<szervezet>"`
3. Inicializálás futtatása: `./scripts/azure-init.sh`
4. Pipeline futtatása parancssorból: `az pipelines run --name "owncloud-dac-pipeline" --project "ownCloud-DaC-Project"`
