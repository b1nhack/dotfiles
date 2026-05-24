#!/bin/zsh

mkdir -p ~/.config/fsh
ln -sf ~/.config/zsh/plugins/zsh-fsh/themes/catppuccin-macchiato.ini ~/.config/fsh/catppuccin-macchiato.ini
# fast-theme XDG:catppuccin-macchiato

ln -sf ~/.config/bat/themes/bat/themes/Catppuccin\ Macchiato.tmTheme ~/.config/bat/themes/Catppuccin\ Macchiato.tmTheme
bat cache --build

ln -sf ~/.config/zsh/.zshenv ~/.zshenv

mkdir -p ~/.local/share/gnupg
chmod 0700 ~/.local/share/gnupg
ln -sf ~/.config/gnupg/gpg.conf ~/.local/share/gnupg/gpg.conf
ln -sf ~/.config/gnupg/gpg-agent.conf ~/.local/share/gnupg/gpg-agent.conf
ln -sf ~/.config/gnupg/dirmngr.conf ~/.local/share/gnupg/dirmngr.conf

ln -sf ~/.config/eza/eza-themes/themes/catppuccin.yml ~/.config/eza/theme.yml

ln -sf ~/.config/pwndbg/.gdbinit ~/.gdbinit
