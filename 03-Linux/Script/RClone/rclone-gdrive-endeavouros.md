---
title: Mount Google Drive con rclone su EndeavourOS
created: 2026-08-15
tags:
  - linux
  - endeavouros
  - arch
  - rclone
  - google-drive
  - systemd
  - nautilus
  - gnome
  - backup
remote: DR-GDrive
mountpoint: /home/stormy/GDrive
status: verificato
---

# Mount Google Drive con rclone su EndeavourOS

> [!info] Contesto
> Guida operativa per montare Google Drive in `~/GDrive` e integrarlo in Nautilus su EndeavourOS con GNOME.
> Remote rclone: `DR-GDrive` — Mountpoint: `/home/stormy/GDrive`
> Presuppone rclone già installato e remote già configurato.

> [!warning] L'integrazione nativa GNOME non esiste più
> Il pacchetto `gvfs-google` è stato rimosso. Il backend Google Drive di GVfs dipendeva da `libgdata`, libreria abbandonata e ultima dipendente da `libsoup2` (insicura). GVfs ha disattivato il backend prima di GNOME 50; l'appello upstream per un manutentore non ha avuto risposta.
> Conseguenza pratica: in **Impostazioni → Account online → Google** il toggle **File** è inerte. Non è un bug della tua installazione.
> rclone è oggi la via standard.

---

## Parte 1 — Setup del mount

### Step 1 — Verificare che il remote risponda

```bash
rclone lsd DR-GDrive:
```

> [!check] Esito atteso
> L'elenco delle cartelle di primo livello del Drive. Se compare, l'autenticazione OAuth è valida e si può proseguire.

---

### Step 2 — Creare la cartella di mount

```bash
mkdir -p ~/GDrive
```

---

### Step 3 — Prova di montaggio in foreground

```bash
rclone mount DR-GDrive: ~/GDrive --vfs-cache-mode writes
```

> [!note] Il comando resta occupato
> Non restituisce il prompt: è il comportamento corretto. Lasciarlo girare e aprire **un secondo terminale** per il passo successivo.

---

### Step 4 — Verificare il mount

Nel **secondo terminale**:

```bash
ls ~/GDrive
```

> [!check] Esito atteso
> Le stesse cartelle viste allo Step 1. Se ci sono, il mount funziona.

---

### Step 5 — Fermare la prova

Tornare al **primo terminale** e premere `Ctrl+C`.

---

### Step 6 — Creare la directory delle unit systemd utente

```bash
mkdir -p ~/.config/systemd/user
```

---

### Step 7 — Scrivere la unit systemd

> [!danger] Incollare il blocco intero in una sola volta
> Va copiato tutto insieme, dalla riga `cat` fino a `EOF` compreso. Modificarlo poi a mano con un editor è il punto in cui è più facile rompere tutto: se salta un a capo, le righe si fondono e rclone riceve argomenti malformati (vedi *Emergenza 4*).

```bash
cat > ~/.config/systemd/user/rclone-gdrive.service << 'EOF'
[Unit]
Description=rclone mount DR-GDrive
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount DR-GDrive: %h/GDrive --vfs-cache-mode writes --vfs-cache-max-age 168h --retries 10 --low-level-retries 20 --log-file=%h/rclone.log --log-level INFO
ExecStop=/usr/bin/fusermount3 -uz %h/GDrive
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF
```

---

### Step 8 — Ricaricare systemd e avviare il servizio

```bash
systemctl --user daemon-reload && systemctl --user enable --now rclone-gdrive.service
```

---

### Step 9 — Controllare lo stato

```bash
systemctl --user status rclone-gdrive.service
```

> [!check] Esito atteso
> `Active: active (running)`
> Se invece compare `activating (auto-restart)` con `Result: exit-code`, il servizio è in loop di riavvio → *Emergenza 4*.

---

### Step 10 — Verificare il mount effettivo

```bash
ls ~/GDrive
```

---

### Step 11 — Segnalibro in Nautilus

Aprire Nautilus, entrare nella cartella `GDrive`, premere `Ctrl+D`.

> [!tip]
> Il trascinamento nella barra laterale può non funzionare nelle versioni recenti di Nautilus. `Ctrl+D` dall'interno della cartella fa la stessa cosa.

---

### Step 12 — Persistenza fuori dalla sessione grafica (opzionale)

```bash
loginctl enable-linger $USER
```

> [!note] Cosa cambia
> - **Senza linger**: il mount c'è a ogni login grafico. Sufficiente per l'uso normale.
> - **Con linger**: il mount c'è anche a macchina accesa senza login, utile per backup automatici, cron, accessi SSH.

Verifica:

```bash
loginctl show-user $USER | grep Linger
```

---

## Parte 2 — Significato dei parametri

| Parametro | Effetto |
|---|---|
| `--vfs-cache-mode writes` | Le scritture passano prima dalla cache locale (`~/.cache/rclone/vfs/`), poi vengono caricate. Minimo indispensabile per semantica POSIX decente (append, seek, rename) |
| `--vfs-cache-max-age 168h` | La cache conserva i file una settimana. Su linea instabile è la differenza tra un upload che riprende e uno perso |
| `--low-level-retries 20` | Ritenta i singoli chunk HTTP falliti. È il parametro che conta davvero sulle micro-interruzioni di linea |
| `--retries 10` | Ritenta l'operazione intera |
| `--log-file` / `--log-level INFO` | Registra tutto in `~/rclone.log`. Indispensabile per capire cosa è successo dopo il fatto |

> [!note] `Type=simple` e non `Type=notify`
> rclone supporta il protocollo sd-notify, ma `simple` è più tollerante alle differenze di versione. Si perde solo la garanzia che systemd consideri il servizio "attivo" esattamente a mount completato.

> [!danger] Mai `--daemon` dentro una unit systemd
> Il processo forkerebbe e systemd ne perderebbe il controllo.

---

## Parte 3 — Comandi rclone di uso quotidiano

### Esplorare il remote

```bash
rclone lsd DR-GDrive:
```

```bash
rclone ls DR-GDrive:NomeCartella
```

```bash
rclone about DR-GDrive:
```

> [!note]
> `lsd` elenca solo le directory, `ls` elenca i file ricorsivamente con le dimensioni, `about` mostra spazio usato e disponibile.

---

### Caricare — il metodo affidabile

> [!warning] Non usare il drag-and-drop nel mount per i file che contano
> Nel mount, Nautilus restituisce il controllo appena la scrittura locale è finita: l'upload prosegue in background e **un fallimento non viene segnalato**. Si crede di aver caricato, e non è vero.
> Per archivi, materiale didattico, backup: usare `rclone copy`.

```bash
rclone copy ~/percorso/locale DR-GDrive:CartellaDestinazione -P
```

> [!tip] Perché è preferibile
> - `-P` mostra progresso, velocità e tempo residuo in tempo reale
> - Termina con un esito esplicito: successo o errore, senza ambiguità
> - È idempotente: se cade, si rilancia lo stesso comando e riprende dai file mancanti senza ricaricare quelli già completi

---

### Scaricare

```bash
rclone copy DR-GDrive:CartellaRemota ~/percorso/locale -P
```

---

### Sincronizzare

```bash
rclone sync ~/percorso/locale DR-GDrive:CartellaDestinazione -P --dry-run
```

> [!danger] `sync` cancella
> A differenza di `copy`, `sync` rende la destinazione **identica** alla sorgente: elimina dalla destinazione tutto ciò che non esiste in locale.
> Eseguire **sempre** prima con `--dry-run`, leggere l'output, e solo dopo rilanciare senza il flag.

---

### Verificare l'integrità

```bash
rclone check ~/percorso/locale DR-GDrive:CartellaDestinazione
```

> [!note] Come leggere l'output
> `file not in Google drive root '...'` significa **mancante sulla destinazione**, non un errore di percorso o di configurazione.
> Discriminante utile: se il percorso fosse sbagliato mancherebbero *tutti* i file, non alcuni. Un numero parziale di mancanti indica upload interrotti.
> La correzione è sempre `rclone copy` (vedi sopra): carica solo ciò che manca.

---

### Altri comandi utili

```bash
rclone size DR-GDrive:NomeCartella
```

```bash
rclone mkdir DR-GDrive:NuovaCartella
```

```bash
rclone cleanup DR-GDrive:
```

```bash
rclone help flags | grep retries
```

> [!note]
> `cleanup` svuota il cestino remoto di Drive e libera spazio.
> L'ultimo comando mostra i valori di default effettivi della versione installata — utile invece di fidarsi della memoria.

---

## Parte 4 — Gestione del servizio

### Stato

```bash
systemctl --user status rclone-gdrive.service
```

### Riavvio

```bash
systemctl --user restart rclone-gdrive.service
```

### Arresto

```bash
systemctl --user stop rclone-gdrive.service
```

### Dopo ogni modifica alla unit

```bash
systemctl --user daemon-reload && systemctl --user restart rclone-gdrive.service
```

### Log in tempo reale

```bash
journalctl --user -u rclone-gdrive.service -f
```

### Ultime 30 righe di log

```bash
journalctl --user -u rclone-gdrive.service -n 30 --no-pager
```

> [!tip] `--no-pager` è importante
> Senza, l'output finisce dentro `less` e viene troncato a schermo: l'errore vero, che sta in fondo, resta invisibile.

### Log di rclone

```bash
tail -f ~/rclone.log
```

### Cercare errori nel log

```bash
grep -i "error\|failed" ~/rclone.log | tail -20
```

---

## Parte 5 — Emergenze

### Emergenza 1 — `Transport endpoint is not connected`

Il processo rclone è morto lasciando il mountpoint sporco.

```bash
fusermount3 -uz ~/GDrive
```

```bash
systemctl --user restart rclone-gdrive.service
```

---

### Emergenza 2 — Mount bloccato o cartella che non risponde

Stessa procedura dell'Emergenza 1. Il flag `-z` (lazy unmount) smonta anche quando ci sono processi che tengono aperto il mountpoint.

---

### Emergenza 3 — `mkdir: cannot create directory: File exists` all'avvio

Residuo di un mount precedente non smontato.

```bash
fusermount3 -uz ~/GDrive && systemctl --user restart rclone-gdrive.service
```

---

### Emergenza 4 — Servizio in loop: `activating (auto-restart)` + `status=2`

> [!danger] Causa più frequente: unit corrotta da un editing manuale
> `status=2` è `INVALIDARGUMENT`: rclone ha ricevuto un argomento malformato. Nella pratica succede quando, modificando il file con nano, salta l'a capo tra `ExecStart` e `ExecStop`, le due righe si fondono e rclone legge qualcosa come `--log-level INFOExecStop=/usr/bin/fusermount3`.

Diagnosi:

```bash
journalctl --user -u rclone-gdrive.service -n 30 --no-pager
```

Cercare la riga `NOTICE: Fatal error:` in fondo all'output — contiene la causa esatta.

Correzione: **riscrivere la unit da zero** con il blocco dello *Step 7*, non ripararla a mano. Poi:

```bash
systemctl --user daemon-reload && systemctl --user restart rclone-gdrive.service
```

---

### Emergenza 5 — Upload sospesi in cache

Verificare se ci sono scritture pendenti:

```bash
du -sh ~/.cache/rclone/vfs/DR-GDrive 2>/dev/null
```

> [!note] Come interpretare
> - **Dimensione sostanziosa** → ci sono upload in attesa; il mount potrebbe riprenderli da solo dopo un restart del servizio.
> - **Vuoto o inesistente** → gli upload sono stati abbandonati. Usare `rclone copy` per rifarli.

---

### Emergenza 6 — Pulizia completa della cache VFS

```bash
systemctl --user stop rclone-gdrive.service
```

```bash
rm -rf ~/.cache/rclone/vfs/DR-GDrive
```

```bash
systemctl --user start rclone-gdrive.service
```

> [!warning]
> Da fare solo dopo aver verificato con l'Emergenza 5 che non ci siano upload pendenti: la cancellazione li perde definitivamente.

---

### Emergenza 7 — Errori 403 `rateLimitExceeded` / `userRateLimitExceeded`

Il remote sta usando le credenziali OAuth condivise di rclone, soggette a quota globale.

Palliativo immediato — aggiungere alla riga `ExecStart`:

```
--tpslimit 10 --tpslimit-burst 20
```

> [!tip] Soluzione strutturale
> Creare un Client ID OAuth proprio nella Google Cloud Console e reinserirlo con `rclone config`. Riferimento canonico: [rclone.org/drive](https://rclone.org/drive/)
> Attenzione: se l'app OAuth resta in stato *Testing*, Google invalida il refresh token ogni 7 giorni. Va portata *In production* dalla schermata di consenso.

---

### Emergenza 8 — Serve riautenticare il remote

```bash
rclone config reconnect DR-GDrive:
```

---

### Emergenza 9 — Il servizio parte prima della rete

```bash
systemctl is-enabled NetworkManager-wait-online.service
```

Se non risulta `enabled`:

```bash
sudo systemctl enable NetworkManager-wait-online.service
```

---

## Parte 6 — File e percorsi di riferimento

| Percorso | Contenuto |
|---|---|
| `~/.config/rclone/rclone.conf` | Configurazione dei remote, **include il refresh token in chiaro** — permessi `600` |
| `~/.config/systemd/user/rclone-gdrive.service` | Unit systemd del mount |
| `~/.cache/rclone/vfs/DR-GDrive/` | Cache VFS: file in attesa di upload e letture cachate |
| `~/rclone.log` | Log di rclone |
| `~/GDrive` | Mountpoint |
| `~/.config/gtk-3.0/bookmarks` | Segnalibri di Nautilus |

Verifica dei permessi sulla configurazione:

```bash
chmod 600 ~/.config/rclone/rclone.conf
```

> [!danger] Non cifrare `rclone.conf` con password
> `rclone config` offre di proteggerlo con passphrase. Farlo **rompe il mount automatico**: il servizio systemd resterebbe bloccato in attesa dell'input.

---

## Note sull'affidabilità di questa guida

> [!info] Trasparenza sulle fonti
> - **Verificato sul campo**: l'intera Parte 1 e le Emergenze 1, 4, 5 sono state eseguite e confermate su questa macchina (EndeavourOS, GNOME, agosto 2026).
> - **Verificato via web**: la rimozione del backend Google Drive da GVfs e l'assenza di `gvfs-google` dai repository Arch — confermate su archlinux.org e sulla documentazione GNOME.
> - **Conoscenza tecnica consolidata, non verificata sulla documentazione corrente**: la semantica dei flag rclone e i comandi delle Parti 3–5. Confidenza alta, ma i valori di default possono variare tra versioni — `rclone help flags` è la fonte autorevole sulla versione installata.
> - Riferimento canonico per il backend Drive: [rclone.org/drive](https://rclone.org/drive/)
