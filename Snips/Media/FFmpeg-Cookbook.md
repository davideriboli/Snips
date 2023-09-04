---
tags: [ffmpeg, video]
---

REF: https://www.marcosbox.org/2023/08/usare-ffmpeg-da-linea-di-comando.html

- Returns a single frame as an image (e.g. searches for the location 0h:0m:14sec:435msec and transforms the frame into a .png file):

```shell

ffmpeg -i input.flv -ss 00:00:14.435 -vframes 1 out.png

```

- It returns an image every second, naming them sequentially _out1.png, out2.png, out3.png_, etc.

```shell

ffmpeg -i input.flv -vf fps=1 out%d.png

``` 

- It returns an image every minute, naming them sequentially _img001.jpg, img002.jpg, img003.jpg,_ etc. The %03d command imposes a three-digit sorting.

```shell

ffmpeg -i myvideo.avi -vf fps=1/60 img%03d.jpg

``` 

- It returns an image every 10 minutes.

```shell

ffmpeg -i test.flv -vf fps=1/600 thumb%04d.bmp

```

- Extracts MP3 VBR audio from video. _QUALITY_ should be replaced with a number from 0 to 9, where 0 indicates the best possible quality.

```shell

ffmpeg -i myvideo.mp4 -codec:a libmp3lame -q:a QUALITY audio.mp3

```

- Converts an mp4 to wepm, good quality (more refs [here](https://video.stackexchange.com/questions/19590/convert-mp4-to-webm-without-quality-loss-with-ffmpeg)).

```shell

ffmpeg  -i input.mp4  -b:v 0  -crf 30  -pass 1  -an -f webm -y /dev/null
ffmpeg  -i input.mp4  -b:v 0  -crf 30  -pass 2  output.webm

```

- Converts an mp4 to ogg, (pay attention to _a_ and _v_ quality: more refs [here](https://superuser.com/questions/1096841/how-do-i-convert-mp4-to-ogv-while-still-retaining-the-same-quality-using-ffmpeg/1096865)).

```shell

ffmpeg -i input.mp4 -c:v libtheora -q:v 7 -c:a libvorbis -q:a 4 output.ogv

```