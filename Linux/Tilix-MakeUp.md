---
tags: [shell, linux, linux, linux]
---
REFs:

- [Pimp My Terminal](https://drasite.com/blog/Pimp%20my%20terminal)
- [Make Your Arch Linux Terminal Awesome 2022](https://www.linuxfordevices.com/tutorials/linux/make-arch-terminal-awesome)

```shell
sudo pacman -Syu

sudo pacman -S git
```

```shell
sudo pacman -S zsh

echo $SHELL # you got bash

chsh
```

The last command will ask for the path to the new shell. Enter */bin/zsh*.

```shell
echo $SHELL # now it's zsh
```

Install the monospaced font that you prefer. I use *Fira Code*.

```shell
yay -S ttf-fira-code
```

```shell
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

gedit .zshrc
```

Change the value of **ZSH_THEME** from *robbyrussell* in *powerlevel10k/powerlevel10k*.

Answer questions in sequence, according to your own taste. Two highly recommended plugins are Autosuggestion and Syntax Highlightiing.

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

gedit .zshrc
```

In the open file, look for the value **“plugins=(git)”** and change it this way:

```shell
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

To get *Neofetch* at launch...

```shell
sudo pacman -S neofetch

gedit .zshrc
```

In the open file simply add *neofetch* to the last line.
