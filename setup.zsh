#!/bin/zsh

ln -s ../zsh/plugins/zsh-fsh/themes/catppuccin-macchiato.ini ~/.config/fsh/catppuccin-macchiato.ini
fast-theme XDG:catppuccin-macchiato

ln -s ./bat/themes/Catppuccin\ Macchiato.tmTheme ~/.config/bat/themes/Catppuccin\ Macchiato.tmTheme
bat cache --build

ln -s ./gitui/theme/macchiato.ron ~/.config/gitui/theme.ron

kitty +kitten themes --reload-in=all Catppuccin-Macchiato

ln -s ./.config/zsh/.zshenv ~/.zshenv
