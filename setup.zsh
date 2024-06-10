#!/bin/zsh

if [[ ! -d "$HOME/.config/fsh" ]]; then
	mkdir -p "~/.config/fsh"
fi
ln -sf ../zsh/plugins/zsh-fsh/themes/catppuccin-macchiato.ini ~/.config/fsh/catppuccin-macchiato.ini
# fast-theme XDG:catppuccin-macchiato

ln -sf ./bat/themes/Catppuccin\ Macchiato.tmTheme ~/.config/bat/themes/Catppuccin\ Macchiato.tmTheme
# bat cache --build

ln -sf ./gitui/theme/macchiato.ron ~/.config/gitui/theme.ron

ln -sf ./.config/zsh/.zshenv ~/.zshenv

ln -sf ../.config/gnupg/gpg.conf ~/.gnupg/gpg.conf
ln -sf ../.config/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
