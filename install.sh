#!/bin/bash

cd "$(dirname "$0")" || exit 1

lns() {
  local src=$1 dst=$2 sudo=$3
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "skip: $dst exists and is not a symlink" >&2
    return
  fi
  $sudo mkdir -p "$(dirname "$dst")"
  $sudo ln -sfn "$src" "$dst"
}

links=links.$(uname)
[ -f "$links" ] || { echo "no $links for this OS" >&2; exit 1; }

while read -r src dst sudo; do
  [[ -z $src || $src == \#* ]] && continue
  if [ ! -e "$src" ]; then
    echo "missing: $src" >&2
    continue
  fi
  lns "$PWD/$src" "${dst/#\~/$HOME}" $sudo
done < "$links"
