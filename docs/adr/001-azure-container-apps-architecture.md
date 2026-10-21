# ADR-001: Azure Container Apps és Managed PostgreSQL használata ownCloud-hoz

## Status
Elfogadva

## Context
Az ownCloud konténerizált futtatásához skálázható, alacsony karbantartási igényű és biztonságos felhőkomponensekre van szükség anélkül, hogy manuális Kubernetes (AKS) cluster-adminisztrációt kellene fenntartani.

## Decision
- **Compute:** Azure Container Apps (ACA) használata a szervermentes konténer-futtatáshoz.
- **Database:** Azure Database for PostgreSQL Flexible Server a robusztus adatintegritásért.
- **Storage:** Azure Files (SMB) a perzisztens fájltároláshoz (`/var/www/html`).

## Consequences
- Nincs szükség node-szintű OS patch-elésre.
- A perzisztens I/O teljesítmény az Azure Files SKU-tól függ.
