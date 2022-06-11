#!/bin/bash
ln -sf $(pwd)/init.lua $HOME/.config/nvim/init.lua

if [[ "$OSTYPE" == "darwin"* ]]; then
	ln -sf $(pwd)/lua $HOME/.config/nvim/lua
else
	ln -sfr $(pwd)/lua $HOME/.config/nvim/lua
fi
