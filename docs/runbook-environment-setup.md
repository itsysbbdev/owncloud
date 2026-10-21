# Runbook: DaC Munkakörnyezet, GHCR Base Image és GitHub Bootstrap

Ez a dokumentum rögzíti az `owncloud-azure-dac` projekt inicializálásának pontos lépéseit és a reproduválható parancsokat.

## 1. Host Mappastruktúra és GitHub Repo Inicializálás
- A projekt a host gépen a `~/projects/owncloud` könyvtárban helyezkedik el (Single Source of Truth).
- Távoli repository: `owncloud-azure-dac` (GitHub).
- Alap DaC struktúra: `docs/c4-model`, `docs/adr`, `configs/terraform`, `configs/ansible`, `configs/docker`, `scripts`.

## 2. Pre-built DevContainer Base Image (GHCR)
Ahelyett, hogy minden projekt indításakor újrafordítanánk a DevContainer feature-öket, a felépített környezetet Docker image-ként mentettük el:
~~~bash
GH_USER=$(gh api user -q .login | tr '[:upper:]' '[:lower:]')
IMAGE_NAME="ghcr.io/${GH_USER}/dac-architect-base:latest"
docker commit <CONTAINER_ID> dac-architect-base:latest
docker tag dac-architect-base:latest "$IMAGE_NAME"
gh auth refresh -h github.com -s write:packages,read:packages
gh auth token | docker login ghcr.io -u "$GH_USER" --password-stdin
docker push "$IMAGE_NAME"
~~~

## 3. Izolált DevContainer Konfiguráció és Mount Előfeltételek
- Konténer neve: `devcontainer-owncloud-dac` (`ownCloud-DaC-Env`).
- **Kritikus előfeltétel a host gépen:** A bind mountok (`.azure`, `.config/gh`) megléte kötelező a konténer indítása előtt, különben a Docker daemon `mount config is invalid` hibát dob:
~~~bash
mkdir -p ~/.azure ~/.config/gh
docker rm -f devcontainer-owncloud-dac 2>/dev/null || true
~~~

## 4. Következő Lépés: Azure Backend és DevOps CI/CD
- A `scripts/azure-init.sh` felelős a Terraform state backend (Azure Storage) és az Azure DevOps pipeline kódból történő létrehozásáért.
