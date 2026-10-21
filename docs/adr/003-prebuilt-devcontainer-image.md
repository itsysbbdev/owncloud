# ADR-003: Projektszintű DevContainer Szeparáció és Pre-built Base Image (GHCR)

## Status
Elfogadva

## Context
A központi DevContainerbe történő többszörös mappa-becsatolás (bind mount) helyett minden DaC projektnek önálló, izolált munkakörnyezetre van szüksége. Ugyanakkor a devcontainer feature-ök (Terraform, Azure CLI, Docker, GH CLI) minden projektnél történő újrafordítása lassú és erőforrás-igényes.

## Decision
- **Projektszintű konténerek:** Minden projekt önálló, elnevezett konténert (`devcontainer-<projekt>-dac`) futtat.
- **Pre-built Base Image:** A felépített környezetet `docker commit` segítségével `dac-architect-base:latest` néven mentjük, és a GitHub Container Registryben (`ghcr.io/itsysbbdev/dac-architect-base:latest`) tároljuk.
- **Hitelesítés megosztása:** A host `.azure` és `.config/gh` profiljai bind mounttal kerülnek becsatolásra az azonnali CLI használathoz.

## Consequences
- Az új DaC projektek konténerei ~1 másodperc alatt elindulnak újrafordítás nélkül.
- A környezet bármely gépről lehúzható a GHCR-ből.
