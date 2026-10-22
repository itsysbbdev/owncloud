# C4 Model: Container Diagram - ownCloud on Azure

Ez a dokumentum az ownCloud platform konténer-szintű felépítését mutatja be a C4 modell alapján.

## Konténer diagram (Mermaid)

```mermaid
C4Container
    title Container Diagram for ownCloud on Azure

    Person(user, "Felhasználó", "Webböngészőn vagy kliensalkalmazáson keresztül éri el a fájlokat.")
    
    System_Ext(dns, "Cloudflare DNS / Edge", "Biztosítja a domain nevet és a TLS terminálást (nc.botzheim.eu).")

    Enterprise_Boundary(azure, "Azure Container Apps Environment") {
        Container(webapp, "ownCloud Web App", "PHP / Container", "Kiszolgálja a webes felületet, kezeli a fájlokat és a felhasználói kéréseket.")
        ContainerDb(db, "MariaDB Database", "Container DB", "Tárolja a felhasználói metaadatokat, beállításokat és jogosultságokat.")
        Container(storage, "Azure Files (SMB)", "Persistent Storage", "Biztonságos, perzisztens tárhely a fájlok és a konfigurációk számára.")
    }

    Rel(user, dns, "HTTPS kérés", "HTTPS / 443")
    Rel(dns, webapp, Proxyzza a forgalmat, "HTTPS")
    Rel(webapp, db, "Olvas / Ír metaadatokat", "TCP / 3306")
    Rel(webapp, storage, "Fájlok és konfig olvasása/írása", "SMB / Mount")
