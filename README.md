## Configs are for:

One branch for both Arch Linux and macOS; OS-specific bits are handled per OS (see below).

-   i3 - Tiling window manager (Linux).
-   AeroSpace - Tiling window manager (macOS).
-   picom - Xorg display compositor (Linux).
-   Polybar - Highly customizable status bar (Linux).
-   alacritty - Fast GPU-accelerated terminal.
-   fish (shell) + fisher + starship (customizable prompt).
-   Neovim - Vim fork (fully configured with LSPs, linters,
    parsers, auto-complete, and a bunch of plugins).
-   rofi - Application launcher and dmenu replacement (Linux).
-   ranger - Terminal file manager (Linux).
-   feh - Wallpaper setter (Linux).
-   kanata - Key remapper (home row mods, caps-word, navigation layer).
-   tmux - Terminal multiplexer.
-   Claude Code (`.claude/`) and Codex CLI (`.codex/`) agent tooling.

These are some of the tools that I use and have customized for my development workflow.

> [!CAUTION]
> Some of the configured files require external dependencies.  
> Make sure to carefully review the files you want to use.

## Usage:

```
$ git clone https://github.com/Fatjon-Gash1/dotfiles.git ~/dotfiles
$ ~/dotfiles/install.sh
```

> [!NOTE]
> The install script is idempotent — safe to re-run. It links everything listed in `links.$(uname)` (`links.Linux` / `links.Darwin`), replaces existing symlinks, and skips (with a warning) any destination that is a real file or directory.
