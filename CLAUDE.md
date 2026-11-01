# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles for Arch Linux (i3) and macOS (AeroSpace), on a single `main` branch. The repo is checked out to `~/dotfiles` and individual configs are symlinked into `~/.config`, `~/`, `/etc` (Linux) by `install.sh`. There is no build, test, or lint pipeline — changes take effect by editing files in place (the live configs are symlinks back into this repo).

## Layout / what each top-level dir is

Shared config dirs symlinked to `~/.config/<name>`: `alacritty`, `fish`, `nvim`, `kanata`. Linux-only: `i3`, `polybar`, `picom`, `ranger`, `rofi`, `feh`, plus `code-flags.conf`, `.xinitrc`, `reflector.conf` and `00-keyboard.conf` (root-owned, into `/etc`). macOS-only: `aerospace`, `.aerospace.toml`. Shared loose files: `starship.toml`, `.tmux.conf`, `.prettierrc`. `git/config`, `git/ignore` and `git/allowed_signers` (public signing keys, one line per machine) link into `~/.config/git/`; machine-specific git settings (credential helper, `safe.directory`) go in the untracked `~/.config/git/local`, which `git/config` includes.

Agent tooling configs are organized to be shared across CLIs:

- `.claude/` → symlinked piecewise into `~/.claude/` (subdirs: `agents/`, `skills/`, `rules/`, `output-styles/`, `hooks/`). MCP servers live in `~/.claude.json` and are NOT in this repo. `settings.json` is tracked but marked assume-unchanged locally (Claude Code rewrites it); `settings.local.json` is gitignored. `plugins/` is app-managed and not tracked.
- `.codex/` → symlinked piecewise into `~/.codex/` (subdirs: `agents/`, `hooks/`, `rules/`, plus `AGENTS.md` and `hooks.json`). Main config (`config.toml` and MCP) lives outside this repo.
- `.agents/skills/` → symlinked to `~/.agents/skills/`, the cross-tool Agent Skills location consumed by Codex.

The `.claude/` tree keeps Claude's native structure. The `.codex/` tree keeps Codex-specific equivalents: global instructions in `AGENTS.md`, hook wiring in `hooks.json`, shell scripts under `hooks/`, command rules under `rules/`, and optional custom agents under `agents/`.

## Install / apply changes

```
~/dotfiles/install.sh
```

The script is idempotent — safe to re-run on an already-installed system. `install.sh` is OS-agnostic; what gets linked is declared in `links.$(uname)` (`links.Linux`, `links.Darwin`), one `src dst [sudo]` per line (`src` relative to the repo root, `~` allowed in `dst`, `#` comments). To link a new config, add a line to the relevant `links.*` file(s) — don't edit `install.sh`. For each entry it creates missing parent dirs and replaces an existing symlink via `ln -sfn`; if the destination exists and is not a symlink it prints `skip: ...` and leaves it untouched, and a missing `src` prints `missing: ...`. A third column `sudo` is for root-owned targets under `/etc`.

Editing any file in this repo updates the live config immediately via the symlink — no reload step beyond whatever the target tool needs (e.g. `i3-msg restart`, `:source` in nvim, `exec fish`).

## Neovim config structure

Entrypoint `nvim/init.lua` loads `lua/sets.lua`, `lua/keymaps.lua`, and `lua/plugins.lua`. Plugin manager is **packer.nvim** (compiled output `nvim/plugin/packer_compiled.lua` is gitignored). Per-plugin setup lives in `nvim/lua/pluginsConf/` with `init.lua` as the dispatcher; add a new plugin by declaring it in `plugins.lua` and creating a matching `pluginsConf/<name>.lua` required from `pluginsConf/init.lua`. After changing `plugins.lua`, run `:PackerSync` inside nvim.

## Fish shell config

`fish/config.fish` is the entrypoint. `fish/conf.d/` is autoloaded (note: `conf.d` is gitignored except `nvm.fish` and `z.fish`, which are force-tracked). `fish/functions/` holds individual function files (one function per file, fish convention). Plugins (z, bass) are vendored: their files are committed directly and there is no plugin manager, so update them by copying in new upstream files. Prompt is starship (`starship.toml` at repo root).

## Per-OS differences

There are no per-OS branches. Shared configs carry small OS checks instead; prefer extending these over duplicating files:

- nvim: `vim.fn.has("mac") == 1` (NvimTree focus keymap, php-cs-fixer, pylint).
- fish: `if test (uname) = Linux` in `config.fish`.
- alacritty: `alacritty.toml` imports `~/.config/alacritty-os.toml`, which `links.*` points at `alacritty/linux.toml` or `alacritty/macos.toml`.
- kanata: `(platform (macos) ...)` / `(platform (linux) ...)` blocks; every layer must keep the same key count as `defsrc`.

## Conventions worth knowing

- `.gitignore` excludes `nvim/plugin/packer_compiled.lua`, `fish/fish_variables`, `fish/conf.d`, `.DS_Store`, `*.bak`, `.claude/settings.local.json` and `.claude/skills/synced/`. Don't try to commit generated/local state in those paths.
- `pkglist.txt` (repo) and `aur.txt` (AUR) are manual snapshots of explicitly installed packages, not auto-generated; see `docs/arch-packages.md`.
- `docs/` holds personal how-to guides (Arch packages, cleanup).
- `checkstyle.xml` and `.prettierrc` are personal style configs used by editors/projects, unrelated to this repo's own tooling.
