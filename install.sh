#!/bin/bash
ln -sf $(pwd)/init.lua $HOME/.config/nvim/init.lua
ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf

if [[ "$OSTYPE" == "darwin"* ]]; then
	ln -sf $(pwd)/lua $HOME/.config/nvim/lua
else
	ln -sfr $(pwd)/lua $HOME/.config/nvim/lua
fi
