---
creato: gio 21/11/2024
tags:
  - linux
---

## Intro

Istruzioni per cambiare profondamente l'aspetto del terminale. Io uso [Tilix](https://gnunn1.github.io/tilix-web/), ma funziona un po' con tutti. Attenzione: è pericoloso! In questo caso, la data di ultima modifica al termine dell'articolo indica l'ultima volta che mi è andata bene nell'applicarle. Se qualcuno là fuori legge queste righe e intende provarci, cerchi in giro materiale aggiornato.

##  Ricetta

```shell
sudo pacman -Syu #Aggiorna il sistema

sudo pacman -S git #Solo se per qualche faccenda per me incomprensibile non avete già installato git sul sistema. In caso contrario (99,99% dei casi se usate Arch o Endeavour) non serve
```

Una volta aggiornato il sistema, è necessario cambiare shell, passando da Bash (che è quella di deafult) a Zsh che installiamo così:

```shell
sudo pacman -S zsh
```

Installare non basta: il comando `echo $SHELL` restituisce quale shell è al lavoro e probabilmente dirà `/bin/bash` che non è quel che vogliamo. Cambiamo shell di lavoro con:

```shell
chsh
```

L'output chiede la pwd di root, poi avvisa che si sta per cambiare shell e infine chiede quale shell si vuole. La risposta giusta è `/bin/zsh`

Per quello che riguarda i caratteri,  è consigliabile la famiglia MesloLGS NF che è un sottoinsieme dei [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts), con tutti i simboli necessari. Questi sono i link per il download diretto; una volta scaricati, per l'installazione basta il tasto destro. Poi, logicamente, vanno richiamati anche nelle preferenze del profilo di terminale.

- [MesloLGS NF Regular.ttf](https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf)
- [MesloLGS NF Bold.ttf](https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf)
- [MesloLGS NF Italic.ttf](https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf)
- [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf)

Installiamo [Oh-My-Zsh](https://ohmyz.sh/) che è di grande aiuto per la configurazione generale. Si può fare in due modi (io uso curl):

*Via Curl*

```shell
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

*Via Wget*

```shell
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

L'output comincia a prendere colore, ma siamo ancora distanti da risultato finale. Accertatevi di essere a casa con:

```shell
cd #non deve dare nessun particolare output
```

Ora installiamo un tema. [Powerlevel10k](https://github.com/romkatv/powerlevel10k) è molto potente e ben documentato.

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Editiamo le preferenze di Zsh con:

```shell
gedit .zshrc
```

Dalle parti di linea 11 il valore `robbyrussell` va cambiato con `powerlevel10k/powerlevel10k`. Salvate, chiudete e lanciate di nuovo il terminale.

Parte un wizard di configurazione. Basta leggere, capire cosa si è letto e premere il tasto corrispondente alla risposta desiderata.

Alla fine della procedura base, installiamo due plugin aggiuntivi che sono davvero utili.

*Zsh Autosuggestion*

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

*Zsh Syntax Highlighting*

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

Torniamo a cambiare le preferenze di Zsh con:

```shell
gedit .zshrc
```

Cercate il valore `plugins=(git)` (di solito tra linea 75 e linea 80) e cambiatelo in `plugins=(git zsh-autosuggestions zsh-syntax-highlighting)`. Controllate anche che l'autocorrezione sia attiva,verificando che il valore `ENABLE_CORRECTION="true"` sia effettivamente così. Salvate tutto, uscite e rilanciate.

Se volete [Neofetch](https://github.com/dylanaraps/neofetch) in apertura, per prima cosa va installato:

```shell
sudo pacman -S neofetch
```

Poi, per l'ennesima volta editiamo le preferenze di Zsh con:

```shell
gedit .zshrc
```

E aggiungiamo una nuova riga alla fine del file, scrivendo semplicemente `neofetch`.

Chiudete tutto, rilanciate e incrociate le dita. Se dopo un po' vi stufate, potete comunque scegliere un tema diverso tra i [tanti disponibili per Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes).

Neofetch alla fine l'ho tolto: è un po' ingombrante da avere ad ogni lancio di terminale. Ho sostituito con [Fortune](https://wiki.archlinux.org/title/Fortune) e [Oblique Strategies Mod](https://aur.archlinux.org/packages/fortune-mod-oblique-strategies). In questo caso, nell'ultima riga del file di configurazione di Zsh va messo `fortune oblique-strategies`.

## Riferimenti esterni

- [Pimp My Terminal](https://drasite.com/blog/Pimp%20my%20terminal)
- [Make Your Arch Linux Terminal Awesome 2022](https://www.linuxfordevices.com/tutorials/linux/make-arch-terminal-awesome)

---

*Ultima modifica: gio 21/11/2024*