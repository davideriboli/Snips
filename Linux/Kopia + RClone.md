---
title: "Kopia CLI: Manuale Operativo Hardware-First"
tags: #backup #sysadmin #cybernetics #linux
last_updated: 2026-05-05
---

# 🛠️ Kopia CLI Management Protocol

Questo manuale contiene la sintassi corretta per la gestione del repository Kopia sull'MSI Vector, ottimizzata per l'uso da terminale con feedback in tempo reale.

## 1. Connessione e Stato
Operazioni preliminari per verificare l'integrità del database locale.

- **Verifica Stato:**
  `kopia repository status`
- **Disconnessione Repository:**
  `kopia repository disconnect`
- **Riconnessione (Filesystem):**
  `kopia repository connect filesystem --path=/mnt/backup_master/kopia-repository`

---

## 2. Policy e Compressione
Configurazione delle regole globali di archiviazione.

- **Impostazione Compressione Globale (ZSTD):**
  `kopia policy set --global --compression=zstd`
- **Verifica Policy Attive:**
  `kopia policy show --global`
- **Configurazione Retention (Esempio: 10 snapshot orari, 7 giornalieri):**
  `kopia policy set --global --keep-hourly=10 --keep-daily=7`

---

## 3. Gestione Snapshot
Operazioni core di acquisizione e monitoraggio dei dati.

- **Creazione Snapshot (con feedback):**
  `kopia snapshot create /home/stormy/cartella --progress`
- **Elenco Sorgenti e Snapshot:**
  `kopia snapshot list`
- **Navigazione Interna ad uno Snapshot (stile ls):**
  `kopia ls -l [SNAPSHOT_ID]`
- **Differenza tra due Snapshot:**
  `kopia diff [ID_1] [ID_2]`

---

## 4. Manutenzione e Purge
Comandi per la gestione dello spazio fisico sul secondo disco NVMe.

- **Eliminazione Snapshot Specifico (tramite ID):**
  `kopia snapshot delete [ID_SNAPSHOT] --delete`
- **Garbage Collection Profonda (Recupero GB immediato):**
  `kopia maintenance run --full --safety=none`
  > [!WARNING]
  > Il flag `--safety=none` bypassa il margine di sicurezza di 24 ore. Utilizzarlo solo quando è necessario liberare spazio istantaneamente.

---

## 5. Sincronizzazione Cloud (Rclone Bridge)
Protocollo per la ridondanza su Tana-S3, PCloud e DR-GDrive.

### Sincronizzazione Sequenziale
Utilizzare i flag di ottimizzazione per mitigare i colli di bottiglia della rete.

```bash
# Sincronizzazione verso PCloud (o altro remote)
kopia repository sync-to rclone \
  --remote-path=PCloud:kopia-master-repo \
  --progress \
  --rclone-args="--transfers=1" \
  --rclone-args="--checkers=2"