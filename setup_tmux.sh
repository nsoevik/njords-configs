#!/bin/sh

TMUX_PLUGINS_DIR="$HOME/.tmux/plugins/tpm"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

ln -sf $REPO_DIR/.tmux.conf $HOME/.tmux.conf

mkdir -p $HOME/.config

echo "Created symbolic links:"
echo ".tmux.conf -> $HOME/.tmux.conf"

if [ ! -d ~/.tmux/plugins/tpm ]; then
git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS_DIR"
else
    echo "~/.tmux/plugins/tpm already exists."
fi

echo "cloned TPM, restart tmux and install plugins: <Leader> + I"

