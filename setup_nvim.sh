#!/bin/sh

NVIM_PAQ_DIR="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"

if [ ! -d "$NVIM_PAQ_DIR" ]; then
git clone --depth=1 https://github.com/savq/paq-nvim.git "$NVIM_PAQ_DIR"
else
    echo "PAQ already exists ($NVIM_PAQ_DIR)."
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

ln -sf $REPO_DIR/nvim $HOME/.config/nvim

mkdir -p $HOME/.config

echo "Created symbolic links:"
echo "nvim config -> $HOME/.config/nvim"
