# C4 Model - System Context (ownCloud on Azure)

- **User / Client:** Böngészőn vagy WebDAV kliensen keresztül eléri az ownCloud rendszert HTTPS-en.
- **System (Azure Container Apps):** Futtatja az `owncloud/server` konténert, kezeli a bejövő HTTP/HTTPS forgalmat (Ingress).
- **Database (Azure Database for PostgreSQL):** Tárolja a metaadatokat, felhasználói fiókokat és beállításokat.
- **Storage (Azure Files):** Perzisztens fájltároló a feltöltött dokumentumok számára.
