---
tags: [video, kiosk mode,]
---
## Info

Istruzioni per gestire un video in Kiosk Mode. L'utente ha solo il controllo del clic del mouse e il mouse non mostra il puntatore. Primo clic, il video parte; secondo clic, il video si interrompe e cosivvia. Se il video giunge al termine, si riavvolge e si ferma, aspettando un altro clic d'avvio.

#### File e struttura
1. Una sola cartella contiene tutti i file:
	- il video (video.mp4)
	- la pagina HTML (index.html)
	- l'alias di Chrome (Google Chrome)

#### Alias Google Chrome

1. Installare l'ultima versione di Google Chrome.
2. Durante l'installazione, creare un alias dell'applicazione in desktop.
3. Modificare la *Destinazione* dell'alias in *Proprietà*, aggiungendo al percorso: *--kiosk*. Quindi, ad esempio sotto Windows:

```shell
"C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk
```

#### HTML

```html
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
}

#myVideo {
  position: fixed;
  right: 0;
  bottom: 0;
  min-width: 100%; 
  min-height: 100%;
}

#myBtn {
  position: fixed;
  width: 100vw;
  height: 100vh;
  border: none;
  cursor: none;
  background: transparent;
  color: transparent;
}

#myBtn:hover {
  background: transparent;
  color: transparent;
}
</style>
</head>
<body>

<video id="myVideo">
  <source src="test.mp4" type="video/mp4">
</video>

  <button id="myBtn" onclick="myFunction()">&nbsp;</button>

<script>
var video = document.getElementById("myVideo");
var btn = document.getElementById("myBtn");

function myFunction() {
  if (video.paused) {
    video.play();
  } else {
    video.pause();
  }
}
</script>

</body>
</html>
```

#### START KIOSK

Drag&Drop di index.html su alias Chrome.

#### STOP KIOSK

Kill task Chrome (ad esempio: CTRL+ALT+CANC in WIndows).
