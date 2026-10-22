# ADR-004: Repository nevének egyszerűsítése és migrálása

## Status
Elfogadva (2026-10-22)

## Kontextus
A kezdeti `owncloud-azure-dac` elnevezés túl hosszú volt, és nem illeszkedett a szabványos, tiszta DaC (Documentation-as-Code) workspace konvenciókhoz. A Nextcloud korábbi instabilitási problémái miatt (Azure Container Apps ephemer fájlrendszer és SMB korlátok) a projekt irányt váltott, és a tiszta, karbantarthatóbb struktúra felé mozdult el.

## Döntés
Áttelepítettük a teljes git előzményt, a C4 modellet és a dokumentációt egy tömör, egységes nevű `itsysbbdev/owncloud` nevű GitHub repository-ba, megszüntetve a felesleges utótagokat. A helyi fejlesztés az Acer-R5-F44 gépen ezentúl kizárólag ebben a dedikált workspace-ben történik.

## Következmények
- Minden hivatkozás, CI/CD pipeline és dokumentáció frissült az új `owncloud` névre.
- A C4/ADR dokumentációs struktúra sértetlenül megmaradt, biztosítva a folyamatos Documentation-as-Code szinkronizációt.
