import pwndbg.commands
import gdb
import os


@pwndbg.commands.Command(category="misc", parser_or_desc="init libslub")
@pwndbg.commands.OnlyWhenRunning
def sbinit():
    path = os.path.expanduser("~/.config/pwndbg/libslub/libslub.py")
    gdb.execute(f"source {path}")
