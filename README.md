## Configs are for:

-   alacritty - Fast GPU-accelerated terminal.
-   fish (shell) + fisher + starship (customizable prompt).
-   Neovim - Vim fork (fully configured with LSPs, linters,
    parsers, auto-complete, and a bunch of plugins).
-   tmux - Terminal multiplexer.

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
> The install script is idempotent — safe to re-run. It links everything listed in `links`, replaces existing symlinks, and skips (with a warning) any destination that is a real file or directory.
