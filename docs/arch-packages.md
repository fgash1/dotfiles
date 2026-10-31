# Arch Packages

*Explicitly installed packages, split by source*

- `pkglist.txt` — official repos
- `aur.txt` — AUR

Run from the repo root.

## Update the lists

```bash
pacman -Qqen > pkglist.txt
pacman -Qqem > aur.txt
```

## Install on a new machine

```bash
sudo pacman -S --needed - < pkglist.txt
yay -S --needed - < aur.txt
```

Review `aur.txt` before installing: packages may have moved to the
official repos, been renamed or abandoned, or be hardware-specific.
