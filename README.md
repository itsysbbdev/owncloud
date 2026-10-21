# ownCloud on Azure - DaC Workspace

Ez a repository az **ownCloud** Azure Container Apps alapú infrastruktúráját és DaC (Documentation-as-Code / C4 / ADR) dokumentációját tartalmazza.

## DevContainer (DiD) Környezet
- **Base Image:** `ghcr.io//dac-architect-base:latest`
- **Container Name:** `devcontainer-owncloud-dac`
- **Workspace Path:** `/workspaces/owncloud`

## Dokumentáció (DaC)
### Runbooks (Műveleti Útmutatók)
- [Környezet Felépítési és Bootstrap Runbook](docs/runbook-environment-setup.md)

### C4 Architekturális Modell
- [C4 Level 1: System Context](docs/c4-model/c4-context.md)
- [C4 Level 2: Container Architecture](docs/c4-model/c4-containers.md)

### Architekturális Döntések (ADR)
- [ADR-001: Azure Container Apps és Managed PostgreSQL](docs/adr/001-azure-container-apps-architecture.md)
- [ADR-002: Azure DevOps és GitHub Integrált CI/CD Pipeline](docs/adr/002-azure-devops-cicd.md)
- [ADR-003: Projektszintű DevContainer Szeparáció és Pre-built Base Image](docs/adr/003-prebuilt-devcontainer-image.md)
