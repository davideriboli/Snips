tags:
  - kobo/audiobooks
  - cli/ffmpeg
  - hardware/kobo-libra-colour
status: validated
last_test: 2026-07-13
---
# Sideload Audiolibri su Kobo (.mp3z)

Il firmware Kobo indicizza gli archivi `.mp3z` estraendo la timeline in base all'ordinamento alfanumerico dei file contenuti nello ZIP.

## Specifiche del Profilo Audio (FFmpeg)
- **Codec:** `libmp3lame`
- **Bitrate:** `64k` (CBR - Constant Bitrate per evitare desincronizzazioni sul timer hardware)
- **Canali:** `1` (Mono)
- **Campionamento:** `44100 Hz`
- **Segmentazione:** Max 1800 secondi (30 minuti) per traccia.
- **Limite Payload:** Archivio complessivo < 200 MB.

## Path di Destinazione
Montare il dispositivo via USB e copiare direttamente in:
`/run/media/$USER/KOBOeReader/Nome_Audiolibro.mp3z`

## Comando base FFMPEG (crea capitoli)

```bash
ffmpeg -i "tuo_audiolibro_originale.mp3" -f segment -segment_time 1800 -c:a libmp3lame -b:a 64k -ac 1 -ar 44100 -id3v2_version 3 %03d.mp3 && zip -mj Il_Tuo_Audiolibro.mp3z [0-9][0-9][0-9].mp3
```

## Comando base FFMPEG (singolo file)

```bash
ffmpeg -i "tuo_audiolibro_originale.mp3" -c:a libmp3lame -b:a 64k -ac 1 -ar 44100 single_track.mp3 && zip -mj Il_Tuo_Audiolibro.mp3z single_track.mp3
```