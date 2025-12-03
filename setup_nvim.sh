#!/bin/sh

NVIM_PAQ_DIR="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$NVIM_PAQ_DIR" ]; then
git clone --depth=1 https://github.com/savq/paq-nvim.git "$NVIM_PAQ_DIR"
else
    echo "PAQ already exists ($NVIM_PAQ_DIR)."
fi

ln -sf $REPO_DIR/nvim $HOME/.config/nvim

mkdir -p $HOME/.config

echo "Created symbolic links:"
echo "nvim config -> $HOME/.config/nvim"
