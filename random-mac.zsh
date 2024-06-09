openssl rand -hex 6 | sed 's/^\(.\{1\}\)./\12/; s/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether
