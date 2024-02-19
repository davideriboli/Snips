---
tags: [data-visualization, generative-art/tools, github, video]
---
REF: https://gource.io/.

The command is very long: pay attention, it's a single line! Better edit it before in a code editor...

```shell
gource -f -1280x720 --camera-mode track --background 333333 --title "YOUR TITLE" \ --hide "mouse,dirnames" --seconds-per-day 0.1 --auto-skip-seconds 1 -o - \ | ffmpeg -y -r 24 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast \ -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4
```