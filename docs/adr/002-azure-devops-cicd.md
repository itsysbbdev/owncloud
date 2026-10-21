# ADR-002: Azure DevOps és GitHub Integrált CI/CD Pipeline

## Status
Elfogadva

## Context
Az ownCloud infrastruktúra (DaC) és konténerkomponensek automatizált életciklus-kezeléséhez kódalapú (Infrastructure-as-Code és Pipeline-as-Code) megközelítésre van szükség.

## Decision
- **Verziókezelés:** GitHub (`owncloud-azure-dac` repository).
- **CI/CD Orchestration:** Azure DevOps Pipelines.
- **Bootstrapping:** Az `scripts/azure-init.sh` parancsfájl automatizálja a projekt, a GitHub Service Connection és a Pipeline regisztrációját Azure CLI használatával.

## Használat
1. Exportáld a GitHub Personal Access Token-t és a szervezet URL-jét:
   ~~~bash
   export GITHUB_PAT="your_github_pat_token"
   export AZURE_DEVOPS_EXT_ORG_URL="https://""[dev.azure.com/your-organization](https://dev.azure.com/your-organization)"
   ~~~
2. Futtasd a bootstrapping scriptet a DiD környezetben:
   ~~~bash
   ./scripts/azure-init.sh
   ~~~
