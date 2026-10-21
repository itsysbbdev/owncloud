#!/bin/bash
set -e

# --- 1. Terraform Azure Backend Változók (a tesztelt sablon alapján) ---
RG_NAME="rg-terraform-state"
LOCATION="austriaeast"
SA_NAME="sttfstate$(shuf -i 10000-99999 -n 1)"
CONTAINER_NAME="tfstate"

# --- 2. Azure DevOps és GitHub Változók ---
GITHUB_OWNER="itsysbbdev"
REPO_NAME="owncloud-azure-dac"
PROJECT_NAME="ownCloud-DaC-Project"
GH_SC_NAME="github-sc-owncloud"
PIPELINE_NAME="owncloud-dac-pipeline"

if [ -z "$AZURE_DEVOPS_EXT_ORG_URL" ]; then
echo "Hiba: Állítsd be az AZURE_DEVOPS_EXT_ORG_URL környezeti változót!"
echo "Példa: export AZURE_DEVOPS_EXT_ORG_URL=https://dev.azure.com/szervezetneve"
exit 1
fi

echo "=== 1. Terraform Azure Backend Bootstrapping ==="
if [ -f "configs/terraform/backend.tf" ]; then
echo "A configs/terraform/backend.tf már létezik, backend létrehozás átugrása."
else
echo "Resource Group: $RG_NAME"
echo "Location: $LOCATION"
echo "Storage Account Name (random): $SA_NAME"

az group create --name "$RG_NAME" --location "$LOCATION" -o none
az storage account create --resource-group "$RG_NAME" \
--name "$SA_NAME" --sku Standard_LRS --encryption-services blob -o none
az storage container create --name "$CONTAINER_NAME" \
--account-name "$SA_NAME" -o none

cat << BackendEOF > configs/terraform/backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "$RG_NAME"
    storage_account_name = "$SA_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "dev.terraform.tfstate"
  }
}
BackendEOF
echo "=== Backend inicializálva és configs/terraform/backend.tf létrehozva! ==="
fi

echo "=== 2. Azure DevOps Projekt Létrehozása ==="
az devops configure --defaults organization="$AZURE_DEVOPS_EXT_ORG_URL" -o none
if az devops project show --project "$PROJECT_NAME" &>/dev/null; then
echo "A(z) $PROJECT_NAME projekt már létezik."
else
az devops project create --name "$PROJECT_NAME" --visibility private -o none
echo "Projekt létrehozva: $PROJECT_NAME"
fi

echo "=== 3. GitHub Service Connection Létrehozása ==="
export AZURE_DEVOPS_EXT_GITHUB_PAT="${GITHUB_PAT:-$(gh auth token)}"
SC_ID=$(az devops service-endpoint github list --project "$PROJECT_NAME" --query "[?name=='$GH_SC_NAME'].id" -o tsv)

if [ -z "$SC_ID" ]; then
GH_URL="https://github.com/${GITHUB_OWNER}/${REPO_NAME}"
SC_ID=$(az devops service-endpoint github create \
--project "$PROJECT_NAME" \
--name "$GH_SC_NAME" \
--github-url "$GH_URL" \
--query id -o tsv)
az devops service-endpoint update --project "$PROJECT_NAME" --id "$SC_ID" --enable-for-all true -o none
echo "GitHub Service Connection létrehozva: $SC_ID"
else
echo "GitHub Service Connection már létezik: $SC_ID"
fi

echo "=== 4. CI/CD Pipeline Létrehozása ==="
if az pipelines show --name "$PIPELINE_NAME" --project "$PROJECT_NAME" &>/dev/null; then
echo "A(z) $PIPELINE_NAME pipeline már létezik."
else
REPO_URL="https://github.com/${GITHUB_OWNER}/${REPO_NAME}"
az pipelines create \
--name "$PIPELINE_NAME" \
--project "$PROJECT_NAME" \
--repository "$REPO_URL" \
--repository-type github \
--branch main \
--service-connection "$SC_ID" \
--yaml-path "azure-pipelines.yml" \
--skip-first-run true -o none
echo "Pipeline sikeresen regisztrálva: $PIPELINE_NAME"
fi

echo "=== Minden Azure DevOps és Backend komponens készen áll! ==="
