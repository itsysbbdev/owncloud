# ownCloud on Azure - DaC Workspace

Ez a repository az **ownCloud** Azure Container Apps alapú infrastruktúráját és DaC (Documentation-as-Code / C4 / ADR) dokumentációját tartalmazza.

## DevContainer (DiD) Környezet
- **Base Image:** `ghcr.io/itsysbbdev/dac-architect-base:latest`
- **Container Name:** `devcontainer-owncloud-dac`

## Architekturális Döntések (ADR)
- [ADR-001: Azure Container Apps és Managed PostgreSQL](docs/adr/001-azure-container-apps-architecture.md)
- [ADR-002: Azure DevOps és GitHub Integrált CI/CD Pipeline](docs/adr/002-azure-devops-cicd.md)
- [ADR-003: Projektszintű DevContainer Szeparáció és Pre-built Base Image](docs/adr/003-prebuilt-devcontainer-image.md)
