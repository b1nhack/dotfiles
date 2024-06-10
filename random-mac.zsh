#!/bin/zsh

mac_addr=$(openssl rand -hex 6 | sed 's/^\(.\{1\}\)./\12/; s/\(..\)/\1:/g; s/.$//')
sudo ifconfig en0 ether $mac_addr

echo "Spoofed MAC address to $mac_addr"
