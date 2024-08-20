#!/bin/zsh

if [[ ! -d "$HOME/.config/fsh" ]]; then
	mkdir -p "~/.config/fsh"
fi
ln -sf ~/.config/zsh/plugins/zsh-fsh/themes/catppuccin-macchiato.ini ~/.config/fsh/catppuccin-macchiato.ini
# fast-theme XDG:catppuccin-macchiato

ln -sf ~/.config/bat/themes/bat/themes/Catppuccin\ Macchiato.tmTheme ~/.config/bat/themes/Catppuccin\ Macchiato.tmTheme
# bat cache --build

ln -sf ~/.config/gitui/gitui/themes/catppuccin-macchiato.ron ~/.config/gitui/theme.ron

ln -sf ~/.config/zsh/.zshenv ~/.zshenv

ln -sf ~/.config/gnupg/gpg.conf ~/.gnupg/gpg.conf
ln -sf ~/.config/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -sf ~/.config/gnupg/dirmngr.conf ~/.gnupg/dirmngr.conf

if [[ ! -d "$HOME/.config/aerc/stylesets" ]]; then
	mkdir -p "~/.config/aerc/stylesets"
fi
ln -sf ~/.config/aerc/aerc/dist/catppuccin-macchiato ~/.config/aerc/stylesets/catppuccin-macchiato
