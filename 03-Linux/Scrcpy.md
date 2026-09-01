---
title: Android Mirroring su Linux (EndeavourOS) tramite scrcpy
created: 2026-09-01
tags:
  - linux/endeavouros
  - android/tools
  - workflow/mirroring
  - cli/scrcpy
aliases:
  - Guida scrcpy EndeavourOS
---

# Android Mirroring & Control su EndeavourOS con scrcpy

Guida operativa per l'integrazione, il mirroring a bassa latenza e il controllo completo di dispositivi Android su **EndeavourOS / Arch Linux** tramite **scrcpy** e **ADB**.

---

## 1. Caratteristiche Principali

- **Latenza ultra-bassa:** 30–120 fps nativi via H.264 / H.265 / AV1.
- **Nessun overhead su Android:** Non richiede permessi di root né app server persistenti installate sul dispositivo.
- **Input & Clipboard bidirezionale:** Mouse, tastiera e sincronizzazione appunti nativa.
- **Inoltro Audio:** Supporto audio integrato (dispositivi con Android $\ge$ 11).
- **Gestione File & Installazione:** Drag & drop per trasferimento file e installazione immediata di file `.apk`.

---

## 2. Installazione (EndeavourOS / Arch Linux)

I pacchetti necessari sono presenti direttamente nei repository ufficiali di Arch:

```bash
sudo pacman -S scrcpy android-tools
```

> [!tip] Verifica installazione
> Controlla la disponibilità dei binari e la versione installata:
> ```bash
> scrcpy --version
> adb version
> ```

---

## 3. Configurazione Dispositivo Android

1. Vai in **Impostazioni $\to$ Informazioni sul telefono**.
2. Tocca ripetutamente (7 volte) la voce **Numero di build** fino a sbloccare le *Opzioni sviluppatore*.
3. Accedi a **Sistema $\to$ Opzioni sviluppatore** e attiva:
   - **Debug USB** (USB debugging).
   - *(Solo per ROM custom/OEM come HyperOS/MIUI, ColorOS, RealmeUI)*: Attiva **Debug USB (Impostazioni di sicurezza)** per abilitare la simulazione dell'input da mouse e tastiera.

---

## 4. Primo Collegamento via Cavo (USB)

1. Collega il dispositivo al computer tramite cavo USB.
2. Controlla il rilevamento del terminale:
   ```bash
   adb devices
   ```
3. Conferma il popup di autorizzazione per l'impronta della chiave RSA sul display dello smartphone (spunta *"Consenti sempre da questo computer"*).
4. Avvia la sessione:
   ```bash
   scrcpy
   ```

---

## 5. Profili di Esecuzione & Flag Essenziali

### Risparmio Energetico & Efficienza Termica
Spegne il display fisico del dispositivo mantenendo attiva la sessione sul monitor del computer:
```bash
scrcpy --turn-screen-off
```

Evita il timeout/blocco del display durante l'utilizzo:
```bash
scrcpy --stay-awake --turn-screen-off
```

### Limite di Risoluzione e Bitrate (per porte USB lente o CPU a basso consumo)
```bash
scrcpy --max-size=1920 --video-bit-rate=8M --max-fps=60
```

### Modalità Solo Input (Senza Video/Audio)
Usa la tastiera fisica del PC per digitare direttamente su Android tramite UHID (emulazione tastiera hardware):
```bash
scrcpy --no-video --no-audio --keyboard=uhid
```

---

## 6. Configurazione Wireless (Wi-Fi)

> [!important] Prerequisito di Rete
> Il PC e lo smartphone devono essere connessi alla stessa sottorete locale (stessa LAN/Wi-Fi).

### Procedura Automatica (da Android 11 in su)
Connetti il telefono via USB, quindi lancia:
```bash
scrcpy --tcpip
```
Scollega il cavo USB: la sessione wireless si avvierà in automatico.

### Procedura Manuale (Porta TCP fissa)
1. Connetti via USB e avvia il demone TCP/IP su porta standard:
   ```bash
   adb tcpip 5555
   ```
2. Individua l'indirizzo IP del telefono (da *Impostazioni $\to$ Info Wi-Fi* o via `ip route`).
3. Connetti `adb` via rete e avvia:
   ```bash
   adb connect 192.168.1.X:5555
   scrcpy --turn-screen-off
   ```
4. Per le sessioni successive (senza ricollegare il cavo):
   ```bash
   scrcpy --tcpip=192.168.1.X:5555 --turn-screen-off
   ```

---

## 7. Mappa delle Scorciatoie da Tastiera

Di default il tasto modificatore (`Mod`) è impostato su **`Alt Sinistro`** oppure **`Super`** (Windows key).

| Azione | Scorciatoia |
| :--- | :--- |
| **Schermo intero** | `Mod` + `f` |
| **Tasto Home** | `Mod` + `h` |
| **Tasto Back / Indietro** | `Mod` + `b` *(oppure tasto destro mouse)* |
| **App Recenti (Multitasking)** | `Mod` + `s` |
| **Accendi / Spegni display dispositivo** | `Mod` + `p` |
| **Regola Volume** | `Mod` + `↑` / `Mod` + `↓` |
| **Apri Tendina Notifiche** | `Mod` + `n` |
| **Chiudi Tendina Notifiche** | `Mod` + `Shift` + `n` |
| **Copia testo da Android a PC** | `Mod` + `c` |
| **Incolla testo da PC su Android** | `Mod` + `v` |
| **Installa Applicazione** | Trascina il file `.apk` nella finestra |
| **Invia File su Memoria Interna** | Trascina qualsiasi file (salvato in `/sdcard/Download/`) |

---

## 8. Automazione: Script di Avvio Rapido

Per velocizzare l'esecuzione, è possibile definire un alias o script dedicato in `~/.bashrc` o `~/.zshrc`:

```bash
# Alias per sessione USB a schermo spento
alias adsp="scrcpy --stay-awake --turn-screen-off --power-off-on-close"

# Funzione per connessione Wi-Fi rapida
adwifi() {
    local ip="$1"
    if [ -z "$ip" ]; then
        echo "Uso: adwifi <IP_ANDROID>"
        return 1
    fi
    scrcpy --tcpip="${ip}:5555" --stay-awake --turn-screen-off --power-off-on-close
}
```