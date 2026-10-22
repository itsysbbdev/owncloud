# ADR-005: Perzisztens tárolás és fájlkezelési stratégia Azure környezetben

## Status
Elfogadva (2026-10-22)

## Kontextus
A Nextcloud és hasonló PHP-alapú rendszerek futtatása során problémák merültek fel az ephemerek (ideiglenes) konténer-fájlrendszerek és az SMB alapú Azure Files hálózati tárak összeférhetetlensége (pl. szimbolikus linkek, zárolások) miatt.

## Döntés
A konfigurációs fájlokat és a felhasználói adatokat szigorúan elválasztjuk a futtató konténer rétegtől. Valódi fájlként (nem symlinkként) kezeljük a konfigurációkat, és dedikált perzisztens volume mountokat használunk az Azure Files eléréséhez, biztosítva a stabil működést konténer-replikáció vagy frissítés esetén is.

## Következmények
- Megszűnnek a "White Screen of Death" (WSOD) típusú, jogosultsági vagy fájlelérési hibák.
- A telepítési és frissítési folyamatok determinisztikussá válnak.
