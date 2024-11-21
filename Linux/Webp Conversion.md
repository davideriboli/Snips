---
tags:
  - shell
  - linux
  - linux
  - linux
  - web
  - imagemagick
---
REFs:

- [How Tol](https://www.tutorialspoint.com/how-to-convert-images-to-webp-format-in-linux)

###### Single file Quality 80

```shell
cwebp -q 80 input.jpg -o output.webp
```


###### Batch Conversion Quality 80

```shell
for i in *.jpg; do cwebp -q 80 "$i" -o "${i%.jpg}.webp"; done
```
