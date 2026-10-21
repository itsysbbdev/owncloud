#!/bin/bash
set -e

# Konfigurációs Változók
ORG_URL="${AZURE_DEVOPS_EXT_ORG_URL:-https://dev.azure.com/your-organization}"
PROJECT_NAME="ownCloud-DaC-Project"
REPO_NAME="owncloud-azure-dac"
GITHUB_OWNER="your-github-username-or-org"
SERVICE_CONNECTION_NAME="github-sc-owncloud"

echo "=== Azure DevOps & GitHub CI/CD Bootstrapping ==="
echo "Organization: $ORG_URL"
echo "Project: $PROJECT_NAME"
echo "GitHub Repo: $GITHUB_OWNER/$REPO_NAME"

# 1. Alapértelmezett Azure DevOps szervezet beállítása
az devops configure --defaults organization="$ORG_URL" -o none

# 2. Azure DevOps Projekt létrehozása (ha még nem létezik)
echo "=== 1. Azure DevOps Projekt létrehozása ==="
if az devops project show --project "$PROJECT_NAME" &>/dev/null; then
  echo "A(z) $PROJECT_NAME projekt már létezik."
else
  az devops project create --name "$PROJECT_NAME" --visibility private --description "ownCloud DaC Infrastructure & Deployment" -o none
  echo "Projekt sikeresen létrehozva."
fi

# 3. GitHub Service Connection létrehozása (GitHub Integráció)
echo "=== 2. GitHub Service Connection konfigurálása ==="
# Megjegyzés: Ehhez szükséges a GITHUB_PAT környezeti változó megléte vagy interaktív bejelentkezés.
if az devops service-endpoint github list --project "$PROJECT_NAME" --query "[?name=='$SERVICE_CONNECTION_NAME'] | length(@)" -o tsv | grep -q "1"; then
  echo "A(z) $SERVICE_CONNECTION_NAME service connection már létezik."
else
  if [ -z "$GITHUB_PAT" ]; then
    echo "Figyelem: GITHUB_PAT környezeti változó nincs beállítva. A GitHub service connection automatikus létrehozásához kézi token szükséges."
  else
    az devops service-endpoint github create \
      --project "$PROJECT_NAME" \
      --name "$SERVICE_CONNECTION_NAME" \
      --github-url "https://github.com/$GITHUB_OWNER/$REPO_NAME" \
      --pat "$GITHUB_PAT" -o none
    echo "GitHub Service Connection sikeresen létrehozva."
  fi
fi

# 4. CI/CD Deployment Pipeline Létrehozása
echo "=== 3. CI/CD Pipeline Létrehozása ==="
if az pipelines show --name "owncloud-dac-pipeline" --project "$PROJECT_NAME" &>/dev/null; then
  echo "A pipeline már létezik."
else
  az pipelines create \
    --name "owncloud-dac-pipeline" \
    --description "Automated Infrastructure & App Deployment Pipeline for ownCloud" \
    --project "$PROJECT_NAME" \
    --repository "$REPO_NAME" \
    --repository-type github \
    --service-connection "$SERVICE_CONNECTION_NAME" \
    --yaml-path "azure-pipelines.yml" -o none
  echo "Pipeline sikeresen regisztrálva a GitHub repóból."
fi

echo "=== Azure DevOps és Pipeline inicializálás kész! ==="
