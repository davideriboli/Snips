---
creato: dom 01/12/2024
tags:
  - linux
  - video
---

## Intro

Rassegna di ricette FFMPEG sgraffignate in giro o via Claude.

##  Ricette

- Restituisce un singolo frame come immagine (nell'esempio, cerca il frame a 0h:0m:14sec:435msec e lo salva come .png):

```shell

ffmpeg -i input.flv -ss 00:00:14.435 -vframes 1 out.png

```

- Restituisce una immagine ogni secondo, nominandole in sequenza:

```shell

ffmpeg -i input.flv -vf fps=1 out%d.png

``` 

- Restituisce una immagine ogni minuto, nominandole in sequenza. Il comando %03d impone ordinamento a tre cifre.

```shell

ffmpeg -i myvideo.avi -vf fps=1/60 img%03d.jpg

``` 

- Restituisce una immagine ogni 10 minuti, nominandole in sequenza.

```shell

ffmpeg -i test.flv -vf fps=1/600 thumb%04d.bmp

```

- Estrae audio da un video e lo salva in mp3 vbr. Il parametro _QUALITY_ va rimpiazzato con un valore tra 0 e 9, dove 0 indica massima qualità.

```shell

ffmpeg -i myvideo.mp4 -codec:a libmp3lame -q:a QUALITY audio.mp3

```

- Converte un mp4 in wepm. Il valore di crf a 0 indica massima qualità. Il miglior rapporto tra peso e qualità è con un crf tra 18 e 25.

```shell
ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 0 -b:v 0 -c:a libopus output.webm
```

- Converte un mp4 in ogv. Il valore di q:v a 10 indica massima qualità. Il miglior rapporto tra peso e qualità è con un q:v tra 6 e 8.

```shell
ffmpeg -i input.mp4 -c:v libtheora -q:v 10 -c:a libvorbis output.ogv
```

---

*Ultima modifica: dom 01/12/2024*
