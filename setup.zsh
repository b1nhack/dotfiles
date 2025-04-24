#!/bin/zsh

if [[ ! -d "$HOME/.config/fsh" ]]; then
	mkdir ~/.config/fsh
fi
ln -sf ~/.config/zsh/plugins/zsh-fsh/themes/catppuccin-macchiato.ini ~/.config/fsh/catppuccin-macchiato.ini
# fast-theme XDG:catppuccin-macchiato

ln -sf ~/.config/bat/themes/bat/themes/Catppuccin\ Macchiato.tmTheme ~/.config/bat/themes/Catppuccin\ Macchiato.tmTheme
# bat cache --build

ln -sf ~/.config/zsh/.zshenv ~/.zshenv

ln -sf ~/.config/gnupg/gpg.conf ~/.gnupg/gpg.conf
ln -sf ~/.config/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -sf ~/.config/gnupg/dirmngr.conf ~/.gnupg/dirmngr.conf

ln -sf ~/.config/eza/eza-themes/themes/catppuccin.yml ~/.config/eza/theme.yml
