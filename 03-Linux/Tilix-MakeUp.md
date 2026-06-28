---
tags: [linux, zsh, terminal, ohmyzsh, p10k]
os: linux
aggiornato: 2026-02-08
---

## Intro

Istruzioni per installare Zsh + Oh My Zsh + Powerlevel10k con funzioni custom (`update-all`, `clean-all`, `grafana-up/down`).

Le configurazioni complete sono in `99-SalaMacchine/Config/`.

##  Ricetta

### 1. Pacchetti base

```shell
yay -Syu zsh git fastfetch ttf-meslo-nerd-font-powerlevel10k fortune-mod-oblique-strategies --noconfirm
chsh -s /usr/bin/zsh
```

### 2. Oh My Zsh + Powerlevel10k + Plugin

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 3. Configurazioni

Copiare `99-SalaMacchine/Config/zshrc` → `~/.zshrc` (sostituendo tutto).

Copiare `99-SalaMacchine/Config/p10k.zsh` → `~/.p10k.zsh` (sostituendo tutto).

```bash
cp "/path/to/vault/99-SalaMacchine/Config/zshrc" ~/.zshrc
cp "/path/to/vault/99-SalaMacchine/Config/p10k.zsh" ~/.p10k.zsh
source ~/.zshrc
```

## Riferimenti esterni

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
