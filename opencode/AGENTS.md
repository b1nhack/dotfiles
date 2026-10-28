# AGENTS.md

## Temp directory

- Write all temporary and scratch files under `/tmp/opencode/<task>/` — one subdirectory per task; never scatter files into `/tmp/` or `/var/tmp/` themselves.
- If a tool needs an environment temp dir, set `TMPDIR` to the task directory.

## No system pollution

- Keep changes inside the current project and `/tmp/opencode/` only. Do not touch system configs, and clean up files you create.
- Never install packages system-wide or user-globally: no `dnf install`, `rpm -ivh`, `npm install -g`, `uv tool install`, or `cargo install`.

## Scripts and tools

- Prefer Python for one-off tasks and scratch scripts. Use uv for all environments and packages — never the system Python or system `pip`:

  ```sh
  mkdir -p /tmp/opencode/<task>/ && cd $_  # create and enter the task dir
  uv venv .venv                            # create the task venv
  uv pip install -p .venv requests         # install into it only
  .venv/bin/python script.py               # run inside it
  uv run --with requests python script.py  # or fully ephemeral
  ```

- One-shot CLI tools: `uvx <tool>` (Python), `npx <tool>` (Node), `podman run --rm` (containers).

## Code comments

- Write all code comments in American English only. Do not use other languages or regional spelling variants (e.g., prefer "color" over "colour", "initialize" over "initialise").
