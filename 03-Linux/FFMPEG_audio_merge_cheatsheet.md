---
title: "FFmpeg Concat & Downmix Mono per Audiolibri"
date: 2026-09-24
tags:
  - cli/ffmpeg
  - audio/audiolibri
  - bash/scripting
  - workflow/obsidian
type: playbook
status: validated
---

# FFmpeg: Concatenazione Sequenziale & Ottimizzazione Audiolibro

Playbook CLI per aggregare capitoli o tracce frammentate con nomi arbitrari (spazi, caratteri speciali) in un unico file MP3 ottimizzato per il parlato.

---

## 1. Il Payload (One-Liner Atomico)

Posizionarsi nella directory target ed eseguire la pipeline:

```bash
find . -maxdepth 1 -type f -name "*.mp3" -print0 | sort -z -V | while IFS= read -r -d '' f; do printf "file '%s'\n" "$(readlink -f "$f")"; done > files.txt && \
ffmpeg -f concat -safe 0 -i files.txt -vn -ac 1 -ar 44100 -b:a 64k -map_metadata -1 -f mp3 output_audiolibro.mp3 && \
rm files.txt
```

---

## 2. Anatomia Tecnica della Pipeline

### Fase 1: Filelist Generation & Sorting Naturale
* `find . -maxdepth 1 -type f -name "*.mp3" -print0`: Scansiona solo la cartella corrente, ignorando sottocartelle ed emettendo delimitatori null (`\0`). Previene rotture causate da spazi o apici nei nomi.
* `sort -z -V`: Ordinamento su stream `\0` con logica **Version/Natural Sort**. Garantisce che `002.mp3` preceda `010.mp3` e che non ci siano salti lessicali.
* `while IFS= read -r -d '' f; do ... done > files.txt`: Costruisce la lista nel formato atteso dal demuxer `concat` di FFmpeg (`file '/path/assoluto/nome.mp3'`).

### Fase 2: Transcoding & Normalizzazione Parlato
* `-f concat -safe 0 -i files.txt`: Istruisce FFmpeg a montare sequenzialmente i file elencati nella playlist temporanea. `-safe 0` abilita l'uso di path assoluti.
* `-vn`: Disattiva l'elaborazione video (strippa copertine embedded non sincronizzate).
* `-ac 1`: Downmix forzato a **mono**. Elimina panning inconsistenti e dimezza il bandwidth necessario.
* `-ar 44100`: Ricampionamento standard voice a $44.1\text{ kHz}$.
* `-b:a 64k`: Bitrate costante a $64\text{ kbps}$. Per voce mono garantisce trasparenza acustica con ingombro minimo (circa $28.8\text{ MB/ora}$).
* `-map_metadata -1`: Rimuove i metadati ereditati dai singoli capitoli per evitare header ID3 corrotti o parziali.

---

## 3. Varianti Operative

### Opzione A: Preservare Capitoli Metadata
Se il file finale necessita di conservare tag ID3 globali dal primo file:
```bash
# Sostituire '-map_metadata -1' con:
-map_metadata 0:s:0
```

### Opzione B: Voice Boost (Normalizzazione Volume)
Se il volume tra le tracce sorgente è disomogeneo, inserire il filtro `loudnorm`:
```bash
ffmpeg -f concat -safe 0 -i files.txt -vn -af "loudnorm=I=-16:TP=-1.5:LRA=11" -ac 1 -ar 44100 -b:a 64k output_audiolibro.mp3
```

---

## 4. Verifica e Sanity Check

Per verificare la conformità dello stream generato senza avviare la riproduzione:

```bash
ffprobe -hide_banner -show_streams -select_streams a:0 output_audiolibro.mp3
```

Parametri attesi in output:
- `channels=1`
- `channel_layout=mono`
- `sample_rate=44100`
- `codec_name=mp3`