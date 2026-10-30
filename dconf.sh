#!/usr/bin/env bash

set -euo pipefail

# Backup only what a fresh install cannot restore on its own:
#   1. Prefix filter (awk): keep hand-configured system settings and input
#      method settings. Excluded: things apps/services recreate automatically
#      (per-app notification registration, proxy written by clash, GTK
#      file-chooser state, Ptyxis auto-generated profiles) and things that
#      cannot carry over (wallpaper image files, fingerprint enrollment,
#      per-VM state), plus sections the user does not care about
#      (app-folder grouping, accessibility, sound theme).
#   2. Default filter (python3 + Gio): drop a section entirely only when
#      every key in it equals its schema default — such sections were
#      written wholesale by apps/settings-daemon, not by the user. A section
#      with at least one non-default key is kept whole (default-valued keys
#      included) so today's behavior stays pinned even if distro defaults
#      change in a future release. Sections whose schema is not installed
#      are kept (cannot be judged).
#   3. Key filter: a few keys are dropped even from kept sections (Shell
#      state such as extensions/favorites/app-grid layout/welcome dialog).

tmp=$(mktemp)
trap 'rm -f "$tmp" "$tmp.out"' EXIT

dconf dump / | awk 'BEGIN{
  # Keep sections equal to or underneath these prefixes.
  split("org/gnome/desktop org/gnome/shell org/gnome/mutter org/gnome/settings-daemon/plugins/media-keys org/gnome/settings-daemon/plugins/power org/gnome/settings-daemon/plugins/color org/gnome/TextEditor org/gnome/system/location desktop/ibus", W, " ")
  # ...except these.
  split("org/gnome/desktop/app-folders org/gnome/desktop/a11y org/gnome/desktop/background org/gnome/desktop/screensaver org/gnome/desktop/notifications org/gnome/desktop/sound org/gnome/shell/weather org/gnome/shell/world-clocks", X, " ")
}
/^\[/ {
  p = 0
  s = $0
  gsub(/[\[\]]/, "", s)
  for (i in W) if (s ~ ("^" W[i] "(/|$)")) { p = 1; break }
  for (i in X) if (s ~ ("^" X[i] "(/|$)")) { p = 0; break }
}
p' >"$tmp"

python3 - "$tmp" <<'PY' >"$tmp.out"
import sys
import warnings

from gi.repository import Gio

with open(sys.argv[1], encoding="utf-8") as f:
    text = f.read()

# Parse the dump into sections of (key, value, raw line).
sections = []
for line in text.splitlines():
    if line.startswith("[") and line.endswith("]"):
        sections.append([line[1:-1], []])
    elif line and sections:
        key, _, val = line.partition("=")
        sections[-1][1].append((key, val, line))

src = Gio.SettingsSchemaSource.get_default()

with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    ids = Gio.Settings.list_schemas() + Gio.Settings.list_relocatable_schemas()

fixed = {}  # schema dconf path -> schema id
reloc = {}  # parent dconf path -> relocatable schema ids
for sid in ids:
    sch = src.lookup(sid, True)
    if sch is None:
        continue
    p = sch.get_path()
    if p:
        fixed[p.strip("/")] = sid
    else:
        # Relocatable schemas live under a path derived from their id with
        # the last component dropped, e.g. org.gnome.desktop.app-folders.
        # folder -> /org/gnome/desktop/app-folders/folders/<name>/.
        parent = "/".join(sid.split(".")[:-1]).replace(".", "/")
        reloc.setdefault(parent, []).append(sid)

def best_schema(section, keys):
    """Schema id for a dump section path, or None when unknown."""
    if section in fixed:
        return fixed[section]
    best, best_score = None, 0
    for parent, sids in reloc.items():
        if not section.startswith(parent + "/"):
            continue
        for sid in sids:
            sch = src.lookup(sid, True)
            score = sum(sch.has_key(k) for k in keys)
            if score > best_score:
                best, best_score = sid, score
    return best

# Keys never backed up, even from kept sections (unwanted customizations).
KEY_DROP = {
    "org/gnome/shell": {"app-picker-layout", "enabled-extensions",
                        "favorite-apps", "welcome-dialog-last-shown-version"},
}

out = []
for section, items in sections:
    drop = KEY_DROP.get(section)
    if drop:
        items = [(k, v, raw) for k, v, raw in items if k not in drop]
        if not items:
            continue
    sid = best_schema(section, [k for k, _, _ in items])
    settings, schema = None, None
    if sid is not None:
        schema = src.lookup(sid, True)
        # Fixed-path schemas must not be created with new_with_path().
        settings = (Gio.Settings.new_with_path(sid, "/" + section + "/")
                    if schema.get_path() is None else Gio.Settings.new(sid))
    # Keep the section unless every key is judgeable and equals its default.
    all_default = True
    for key, _, _ in items:
        if settings is None or not schema.has_key(key):
            all_default = False  # unjudgeable: keep the section
            break
        user = settings.get_user_value(key)
        default = settings.get_default_value(key)
        if user is None or default is None or user.print_(True) != default.print_(True):
            all_default = False
            break
    if not all_default:
        if out:
            out.append("")  # blank line between sections, for readability
        out.append("[" + section + "]")
        out.extend(raw for _, _, raw in items)

print("\n".join(out))
PY

mv "$tmp.out" dconf.ini

wc -l dconf.ini
