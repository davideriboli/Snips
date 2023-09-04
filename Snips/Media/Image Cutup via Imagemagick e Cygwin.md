---
tags: [generative-art/script, shell, imagemagick]
---
## Info

-   Installare Cygwin dal [sito ufficiale](https://www.cygwin.com/) o via Chocolatey (vedi [[Chocolatey101]]).
-   Installare [Imagemagick](https://imagemagick.org/index.php) in Cygwin, attraverso l’installer dedicato.
-   Spostare lo _script_ (vedi sotto) nella propria _Home_ Cygwin ed eseguirlo col solito comando:

```shell
./nomedelloscript.sh
``` 

#### CutUp Script:

```shell
#!/bin/bash
echo "Preparazione..."
origgeom=$(identify -format %g input.jpg)
echo "Analisi dimensioni... Ok!"
echo $origgeom
newgeom=$(convert input.jpg -format "%[fx:int(w/10)*5]x%[fx:int(h/5)*10]" info:)
sleep 5
echo "Calcolo dimensioni e immagini... Ok!"
echo $newgeom
convert input.jpg -resize $newgeom -crop 10x5@ tile.png
sleep 10
echo "Taglio... Ok!"
montage -background none -geometry +0+0 $(ls tile*png | awk 'BEGIN{srand()}{print rand() "\t" $0}' | sort -n | cut -f2-) JPG:- | convert JPG: -resize ${origgeom}! output.jpg
echo "Generazione montaggio casuale... Ok!"
```