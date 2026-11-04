#!/usr/bin/env bash

set -euo pipefail

# Export every package explicitly installed via dnf, one entry per line,
# sorted. Intended usage: ./dnf.sh > dnf.txt
#
# All transactions from "dnf history" are replayed in chronological order,
# so an entry that was later removed -- manually, by "dnf autoremove", or by
# obsoletion -- drops out, while a removed-then-reinstalled one comes back.
#
# A package counts as "installed by me" when dnf recorded its install
# reason as User (named on the command line, or "dnf mark install").
# Packages a group brought in (reason Group) are not listed one by one:
# only the group itself is, as "@<group-id>" (or "@^<env-id>" for
# environments) -- reinstalling the group pulls its members in again.
# Dependency and Weak installs are skipped entirely: they resolve
# automatically when their parent package is installed again.
#
# Transactions skipped:
#   - Status is not Ok (failed or aborted, package list not trustworthy)
#   - description starts with "dnf5 --config" (OS image build such as kiwi;
#     that is the preinstalled baseline, not packages chosen on this machine)
#
# kernel* packages are never listed: upgrades install new and autoremove old
# ones with reason "User", which would make them flicker in and out of the
# record; they are managed by the system either way.
#
# Finally, package names that are mandatory or default members of a listed
# group are dropped (queried via "dnf group info"; optional members are
# kept, because "dnf install @group" does not pull them in), and the rest
# is intersected with the live rpmdb: history can end a package with a bare
# "Replaced" line (dropped by a release upgrade, no new version), so the
# rpmdb is the authority on "still installed".

# All transaction IDs, oldest first.
ids=$(LC_ALL=C dnf history list | awk 'NR>1 && $1 ~ /^[0-9]+$/ {print $1}' | sort -n)

# 1. Replay history. Emits user-installed package names and @group ids.
replay=$(
    for id in $ids; do
        LC_ALL=C dnf history info "$id"
    done | awk '
# Strip arch, release and version from a NEVRA, keeping the bare name:
# virt-manager-0:5.1.0-4.fc44.noarch -> virt-manager
function name_of(n) {
    sub(/\.[^.]*$/, "", n)  # .arch
    sub(/-[^-]*$/, "", n)   # -release
    sub(/-[^-]*$/, "", n)   # -epoch:version
    return n
}
/^Transaction ID/ { ok = 0; image = 0; sec = "" }
/^Status/ { ok = ($3 == "Ok") }
/^Description/ { image = ($0 ~ /: dnf5 --config/) }
/^Packages altered:/ { sec = "pkg"; next }
/^Groups altered:/ { sec = "grp"; next }
/^Environments altered:/ { sec = "env"; next }
!ok || image { next }
sec == "pkg" && NF >= 3 && $1 != "Action" {
    if ($1 == "Reason" && $2 == "Change") {
        # "dnf mark install/remove" retags a package without touching rpmdb.
        n = name_of($3)
        if ($4 == "User") want[n] = 1
        else if ($4 == "Dependency" || $4 == "Clean") want[n] = 0
        next
    }
    n = name_of($2)
    if (n ~ /^kernel(-|$)/) next
    if (($1 == "Install" || $1 == "Reinstall") && $3 == "User") want[n] = 1
    else if ($1 == "Remove" || $1 == "Obsolete") want[n] = 0
    # Upgrade / Downgrade / Replaced keep the name installed: ignore.
    # Group-reason installs are covered by their @group entry instead.
}
(sec == "grp" || sec == "env") && NF >= 3 && $1 != "Action" {
    tag = (sec == "env") ? "@^" : "@"
    if ($1 == "Install" && $3 == "User") want[tag $2] = 1
    else if ($1 == "Remove") want[tag $2] = 0
}
END { for (n in want) if (want[n]) print n }
'
)

groups=$(printf '%s' "$replay" | grep '^@' || true)
names=$(printf '%s' "$replay" | grep -v '^@' || true)

# 2. Drop group members: "dnf install @group" reinstalls them anyway.
covered=$(
    for g in $(printf '%s' "$groups" | sed -e 's/^@^//' -e 's/^@//'); do
        LC_ALL=C dnf group info "$g" 2>/dev/null || true
    done | awk '
function emit(line) {
    sub(/^[ \t]*(Mandatory|Default)[ \t]+packages[ \t]*:/, "", line)
    sub(/^[ \t]*:/, "", line)
    gsub(/^[ \t]+/, "", line)
    gsub(/[ \t]+$/, "", line)
    if (line != "") print line
}
/^[ \t]*(Mandatory|Default)[ \t]+packages[ \t]*:/ { keep = 1; emit($0); next }
/^[ \t]*Optional[ \t]+packages[ \t]*:/ { keep = 0; next }
/^[^ \t]/ { keep = 0 }
keep { emit($0) }
' | LC_ALL=C sort -u
)
if [ -n "$covered" ]; then
    names=$(printf '%s' "$names" | LC_ALL=C grep -vxF -f <(printf '%s' "$covered") || true)
fi

# 3. Keep only names still present in the live rpmdb.
names=$(LC_ALL=C comm -12 \
    <(rpm -qa --qf '%{NAME}\n' | LC_ALL=C sort -u) \
    <(printf '%s' "$names" | LC_ALL=C sort))

# 4. Emit, sorted ("@" sorts before letters, so groups come first).
{
    [ -z "$groups" ] || printf '%s\n' "$groups"
    [ -z "$names" ] || printf '%s\n' "$names"
} | LC_ALL=C sort
