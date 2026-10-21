# C4 Model - Level 2: Container Diagram (ownCloud on Azure)

## Konténerek és Infrastruktúra Elemzése
1. **ownCloud Application Container (Azure Container Apps):**
   - Image: `owncloud/server:latest`
   - Port: 8080 (Külső HTTPS Ingress-szel publikálva).
2. **Database Backend (Azure Database for PostgreSQL - Flexible Server):**
   - Relációs adatbázis a felhasználói metaadatok, jogosultságok és fájlszerkezet tárolására.
3. **Persistent Storage (Azure Files - SMB / Storage Account):**
   - A `/mnt/data` útvonalra felcsatolt perzisztens tárhely a feltöltött fájlok számára.
4. **CI/CD & State Backend (Azure DevOps + Azure Blob Storage):**
   - A `tfstate` konténer tárolja a Terraform állapotfájlt (`owncloud.terraform.tfstate`).
