#!/bin/sh

REPO_DIR=$HOME/njords-configs

ln -sf $REPO_DIR/nvim $HOME/.config/nvim
ln -sf $REPO_DIR/.tmux.conf $HOME/.tmux.conf

mkdir -p $HOME/.config

echo "Created symbolic links:"
echo "nvim config -> $HOME/.config/nvim"
echo ".tmux.conf -> $HOME/.tmux.conf"
