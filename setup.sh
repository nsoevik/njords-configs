#!/bin/sh

git clone --depth=1 https://github.com/savq/paq-nvim.git ~/.local/share/nvim/site/pack/paqs/start/paq-nvim

REPO_DIR=$HOME/njords-configs

ln -sf $REPO_DIR/nvim $HOME/.config/nvim
ln -sf $REPO_DIR/.tmux.conf $HOME/.tmux.conf

mkdir -p $HOME/.config

echo "Created symbolic links:"
echo "nvim config -> $HOME/.config/nvim"
echo ".tmux.conf -> $HOME/.tmux.conf"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "cloned TPM, restart tmux and command <Leader> + I"
