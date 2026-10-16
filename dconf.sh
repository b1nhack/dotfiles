#!/usr/bin/env bash

set -euo pipefail

dconf dump / | awk 'BEGIN{
  split("org/gnome/desktop/input-sources org/gnome/desktop/interface org/gnome/desktop/wm/keybindings org/gnome/shell/keybindings org/gnome/shell/app-switcher org/gnome/settings-daemon/plugins/media-keys com/github/libpinyin org/gnome/mutter org/gnome/settings-daemon/plugins/power org/gnome/desktop/peripherals/touchpad org/gnome/desktop/sound org/gnome/system/location org/gnome/TextEditor", W, " ")
}
/^\[/ {
  p = 0
  s = $0
  gsub(/[\[\]]/, "", s)
  for (i in W) if (s ~ "^" W[i]) { p = 1; break }
}
p' >dconf.ini

c=$(cat dconf.ini)
printf '%s\n' "$c" >dconf.ini

wc -l dconf.ini
