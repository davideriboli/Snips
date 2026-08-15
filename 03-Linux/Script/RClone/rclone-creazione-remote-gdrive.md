---
title: Creazione del remote rclone per Google Drive
created: 2026-08-15
tags:
  - linux
  - endeavouros
  - arch
  - rclone
  - google-drive
  - oauth
  - google-cloud-console
  - configurazione
remote: DR-GDrive
scope: drive
status: verificato-su-documentazione-ufficiale
fonte: https://rclone.org/drive/
---

# Creazione del remote rclone per Google Drive

> [!info] Contesto
> Guida per creare da zero il remote `DR-GDrive`, inclusa la generazione di Client ID e Client Secret propri nella Google Cloud Console.
> Presuppone rclone già installato.
> Documento complementare: la guida al mount e alla gestione quotidiana.

> [!danger] Il Client ID proprio non è più opzionale
> Il `client_id` condiviso di rclone **verrà ritirato e smetterà di funzionare nel corso del 2026**. La documentazione ufficiale è esplicita: crearne uno proprio è ora *richiesto*, non semplicemente raccomandato. `rclone config` avvisa se si lascia il campo vuoto.
> Beneficio collaterale: ogni `client_id` ha una quota globale propria (circa 10 transazioni/secondo). Con quello condiviso si finisce in throttling insieme a tutti gli altri utenti del mondo.

---

## Parte 1 — Google Cloud Console

> [!note] Questa parte è interamente grafica
> Nessun comando da terminale fino alla Parte 2. I nomi dei pulsanti sono quelli della documentazione rclone aggiornata a luglio 2026; l'interfaccia Google cambia con frequenza, quindi vanno letti come indicazioni di percorso più che come etichette letterali.

### Step 1 — Accedere alla Console

Aprire [Google API Console](https://console.developers.google.com/) e autenticarsi.

> [!tip]
> L'account Google usato qui **non deve necessariamente essere** quello del Drive a cui si vuole accedere. Sono due cose indipendenti.

---

### Step 2 — Selezionare o creare un progetto

Selezionare un progetto esistente, oppure crearne uno nuovo. Il nome è libero.

---

### Step 3 — Abilitare la Google Drive API

Da **ENABLE APIS AND SERVICES**, cercare `Drive` e abilitare **Google Drive API**.

---

### Step 4 — Aprire il pannello Credentials

Cliccare **Credentials** nel pannello di sinistra.

> [!warning] Non "Create credentials"
> Il pulsante *Create credentials* apre un wizard diverso. Serve la voce **Credentials** del menu laterale.

---

### Step 5 — Configurare la schermata di consenso OAuth

Se non è già stata configurata, cliccare **CONFIGURE CONSENT SCREEN** (in alto a destra nel pannello), poi **Get started**.

Nella schermata successiva:

| Campo | Valore |
|---|---|
| Application name | `rclone` va bene |
| User Support Email | la propria email |
| Audience | **External** |
| Contact information | i propri dati |

Accettare i termini e cliccare **Create**.

> [!note] External vs Internal
> **Internal** è disponibile solo per utenti Google Workspace e limita l'uso dell'API agli account della propria organizzazione. Per un account Google personale, **External** è l'unica scelta possibile.

---

### Step 6 — Aggiungere gli scope

Cliccare **Data Access** nel pannello di sinistra, poi **Add or remove scopes**.

Gli scope necessari sono tre:

```
https://www.googleapis.com/auth/docs
https://www.googleapis.com/auth/drive
https://www.googleapis.com/auth/drive.metadata.readonly
```

> [!tip] Scorciatoia
> Invece di cercarli uno per uno nell'elenco, scorrere fino alla casella **Manually add scopes** e incollare i tre indirizzi separati da virgola, senza spazi:
> ```
> https://www.googleapis.com/auth/docs,https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/drive.metadata.readonly
> ```
> Poi **Add to table** → **Update**.

> [!danger] Non dimenticare il salvataggio
> Dopo aver visto i tre scope elencati nella pagina Data Access, premere **Save** in fondo alla pagina. È un passaggio che sfugge facilmente, e senza di esso la configurazione non viene applicata.

Lo scope `drive` è quello che consente a rclone di leggere, creare, modificare ed eliminare file.

---

### Step 7 — Aggiungersi come utente di test

Cliccare **Audience** nel pannello di sinistra, scorrere fino a **+ Add users**, aggiungere il proprio indirizzo email e salvare.

---

### Step 8 — Creare il client OAuth

Andare su **Overview** nel pannello di sinistra e cliccare **Create OAuth client**.

Tipo di applicazione: **Desktop app**. Il nome predefinito va bene. Cliccare **Create**.

---

### Step 9 — Annotare Client ID e Client Secret

Vengono mostrati a schermo. Copiarli in un posto sicuro.

Hanno questa forma:

```
Client ID:     1234567890-abcdefghijklmnop.apps.googleusercontent.com
Client Secret: GOCSPX-xxxxxxxxxxxxxxxxxxxxxxxx
```

> [!warning] Sono credenziali
> Vanno trattate come una password. Finiranno in chiaro dentro `~/.config/rclone/rclone.conf`.

---

### Step 10 — Pubblicare l'app

Tornare su **Audience** e cliccare **PUBLISH APP**, poi confermare.

> [!danger] Questo passaggio evita la riautenticazione settimanale
> Se l'app resta in stato *Testing*, **Google invalida i token ogni 7 giorni**: il remote smette di funzionare e va riautenticato di continuo. Pubblicandola, il problema sparisce.

> [!note] L'app resterà "non verificata", ed è normale
> Google prevede in teoria una procedura di verifica che richiede settimane. In pratica non serve: la documentazione ufficiale rclone segnala che Google **esenta dalla verifica obbligatoria le app per uso personale** (sotto i 100 utenti) e quelle in sviluppo/test.
> L'unica conseguenza è una schermata di avviso durante l'autorizzazione nel browser. Si supera con **Advanced → Go to (nome app)**, e capita solo in fase di configurazione del remote.

---

## Parte 2 — Configurazione del remote in rclone

### Step 11 — Avviare la configurazione

```bash
rclone config
```

---

### Step 12 — Seguire il wizard

Sequenza delle risposte:

| Prompt | Risposta |
|---|---|
| `e/n/d/r/c/s/q>` | `n` (New remote) |
| `name>` | `DR-GDrive` |
| `Storage>` | `drive` |
| `client_id>` | incollare il Client ID |
| `client_secret>` | incollare il Client Secret |
| `scope>` | `1` (Full access — corrisponde a `drive`) |
| `service_account_file>` | invio (vuoto) |
| `Continue using the shared client_id anyway?` | `n` |
| `Use web browser to automatically authenticate?` | `y` |
| `Configure this as a Shared Drive (Team Drive)?` | `n` |
| `Keep this "DR-GDrive" remote?` | `y` |
| menu finale | `q` |

> [!warning] Digitare `drive`, non il numero
> Al prompt `Storage>` l'elenco dei backend è numerato, ma la numerazione **cambia tra versioni di rclone**. Scrivere la stringa `drive` è l'unico modo affidabile.

> [!note] Il doppio prompt per le credenziali
> Nelle versioni recenti, se si risponde `n` a *"Continue using the shared client_id anyway?"*, rclone **richiede di nuovo** `client_id` e `client_secret`. Non è un errore: reincollare gli stessi valori.

> [!tip] Cosa succede con `y` sul browser
> rclone avvia un webserver locale temporaneo su `http://127.0.0.1:53682/` per raccogliere il token restituito da Google. Resta attivo solo dal momento in cui apre il browser a quando riceve il codice.
> Se è attivo un firewall sull'host, potrebbe essere necessario sbloccare temporaneamente quella porta.
> Da macchina senza browser (SSH, headless): rispondere `n` e seguire la procedura di [remote setup](https://rclone.org/remote_setup/).

---

### Step 13 — Verificare che il remote risponda

```bash
rclone lsd DR-GDrive:
```

> [!check] Esito atteso
> L'elenco delle cartelle di primo livello del Drive. Se compare, l'autenticazione OAuth è valida.

---

### Step 14 — Verificare la quota

```bash
rclone about DR-GDrive:
```

Mostra spazio totale, usato, occupato dal cestino e da altri servizi Google.

---

### Step 15 — Mettere in sicurezza il file di configurazione

```bash
chmod 600 ~/.config/rclone/rclone.conf
```

> [!danger] Contiene il refresh token in chiaro
> Insieme a Client ID e Secret. Chiunque possa leggere questo file ha accesso al Drive.

> [!danger] Non cifrarlo con password
> `rclone config` offre l'opzione *Set configuration password*. **Non usarla** se si intende montare il Drive automaticamente via systemd: il servizio resterebbe bloccato in attesa dell'input della passphrase.

---

## Parte 3 — Riferimenti sugli scope

Lo scope determina cosa rclone può vedere e fare. Si sceglie al prompt `scope>` durante la configurazione.

| Valore | Numero | Cosa consente |
|---|---|---|
| `drive` | 1 | Accesso completo a tutti i file, escluso l'Application Data Folder. **È la scelta predefinita e quella giusta se non si hanno esigenze particolari** |
| `drive.readonly` | 2 | Sola lettura: elencare e scaricare, ma non caricare, rinominare o eliminare |
| `drive.file` | 3 | Solo i file creati da rclone stesso. I file caricati dall'interfaccia web restano invisibili |
| `drive.appfolder` | 4 | Area privata di rclone, invisibile dall'interfaccia web |
| `drive.metadata.readonly` | 5 | Solo i nomi dei file, nessun accesso al contenuto |

> [!tip] Caso d'uso di `drive.file`
> Utile se si usa rclone solo per backup e si vuole la garanzia che non possa accedere a materiale riservato già presente sul Drive.

> [!note] Cambiare scope a posteriori
> Richiede di rieseguire l'autorizzazione: lo scope è inciso nel token OAuth. Si passa da `rclone config` scegliendo `e` (Edit) sul remote esistente.

---

## Parte 4 — Manutenzione del remote

### Elencare i remote configurati

```bash
rclone listremotes
```

### Modificare un remote esistente

```bash
rclone config
```

Poi scegliere `e` (Edit remote) e selezionare `DR-GDrive`.

### Riautenticare senza rifare tutta la configurazione

```bash
rclone config reconnect DR-GDrive:
```

> [!tip] Quando serve
> Token scaduto o revocato, password Google cambiata, permessi revocati dalle impostazioni di sicurezza dell'account Google. Rilancia solo il flusso OAuth, conservando Client ID, Secret e scope.

### Rinominare un remote

```bash
rclone config
```

Poi `r` (Rename remote).

> [!warning]
> Rinominare il remote **rompe la unit systemd del mount**, che lo referenzia per nome. Va aggiornata di conseguenza.

### Eliminare un remote

```bash
rclone config delete DR-GDrive
```

### Ispezionare la configurazione

```bash
rclone config show DR-GDrive
```

> [!danger]
> L'output include il token in chiaro. Da non incollare in forum, issue o chat.

### Verificare la versione installata

```bash
rclone version
```

---

## Parte 5 — Problemi noti in fase di creazione

### Errore 403 `rateLimitExceeded` / `userRateLimitExceeded`

Il remote sta usando il `client_id` condiviso. La soluzione è questa guida: rifare la configurazione con credenziali proprie.

Palliativo temporaneo, da aggiungere ai comandi rclone:

```
--tpslimit 10 --tpslimit-burst 20
```

---

### Riautenticazione richiesta ogni 7 giorni

App OAuth rimasta in stato *Testing*. Tornare allo **Step 10** e pubblicarla.

---

### Schermata "app non verificata" durante l'autorizzazione

È il comportamento atteso per un'app non sottoposta a verifica Google. Cliccare **Advanced** → **Go to (nome app)**.

Capita solo durante la configurazione del remote, non nell'uso quotidiano.

---

### Errore "The request failed because changes to one of the field of the resource is not supported"

Errore noto nella creazione del consent screen. La documentazione rclone indica un aggiramento: generare le credenziali dalla pagina [Python Quickstart](https://developers.google.com/drive/api/v3/quickstart/python) di Google, premendo il pulsante di abilitazione della Drive API, che restituisce Client ID e Secret.

> [!warning]
> Questo metodo crea automaticamente un nuovo progetto nella API Console. Da tenere presente se si gestiscono più progetti.

---

### Il browser non si apre automaticamente

rclone stampa comunque l'indirizzo a schermo:

```
http://127.0.0.1:53682/auth
```

Aprirlo manualmente. Se non risponde, verificare che un firewall locale non stia bloccando la porta 53682.

---

## Parte 6 — Limiti noti di Google Drive

> [!note] Non sono limiti di rclone
> Sono vincoli imposti da Google, utili da conoscere prima di pianificare trasferimenti grossi.

| Limite | Valore |
|---|---|
| Rate limit generale | rclone risulta limitato a circa 2 file/secondo. I singoli file possono viaggiare a centinaia di MiB/s, ma molti file piccoli richiedono molto tempo |
| Upload giornaliero | circa 750 GiB (limite non documentato ufficialmente) |
| Download giornaliero | circa 10 TiB (limite non documentato ufficialmente) |
| Copie server-side | soggette a un rate limit separato. In caso di `User rate limit exceeded`, attendere 24 ore |
| Revisioni dei file | conservate 30 giorni o 100 revisioni, il primo dei due. Non contano nella quota |

> [!warning] I Google Docs nativi
> Non hanno una dimensione reale finché non vengono esportati: compaiono come `-1` in `rclone ls` e come `0` attraverso il layer VFS (quindi in `rclone mount`).
> Conseguenza pratica: **scaricare un Google Doc dal mount può restituire un file di 0 byte**. Si trasferiscono correttamente con `rclone copy` e `rclone sync`, che sanno ignorare la dimensione.

---

## Note sull'affidabilità di questa guida

> [!info] Trasparenza sulle fonti
> - **Verificato sulla documentazione ufficiale**: l'intera guida è stata redatta a partire da [rclone.org/drive](https://rclone.org/drive/), pagina il cui sorgente risulta aggiornato al 31 luglio 2026. Ne derivano direttamente: il ritiro del `client_id` condiviso nel 2026, la sequenza della Cloud Console (Parte 1), il flusso del wizard incluso il nuovo prompt sul client condiviso, la tabella degli scope, i limiti della Parte 6 e i problemi noti della Parte 5.
> - **Non verificato sul campo**: a differenza della guida al mount, questa procedura non è stata eseguita passo per passo su questa macchina. Il remote `DR-GDrive` esisteva già.
> - **Punto di fragilità prevedibile**: le etichette dell'interfaccia Google Cloud Console cambiano spesso, e la documentazione rclone stessa è stata in passato in ritardo su questi cambiamenti. Se una voce non si trova con il nome indicato, cercarne l'equivalente funzionale invece di fermarsi.
> - Riferimento canonico da riconsultare in caso di divergenze: [rclone.org/drive/#making-your-own-client-id](https://rclone.org/drive/#making-your-own-client-id)
