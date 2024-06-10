#!/bin/zsh

first_name=$(sed "$(jot -r 1 1 2048)q;d" first-names.txt)
sudo scutil --set ComputerName "$first_name"
sudo scutil --set LocalHostName "$first_name"

echo "Spoofed hostname to $first_name"
