fish_vi_key_bindings

set -Ux  GIT_EDITOR "nvim"
set -Ux  EDITOR "nvim"

alias v='nvim'
alias cat='bat'
alias x="exit"
alias gg="lazygit"

function config
	v ~/.config/fish/config.fish
end

function reload 
	source ~/.config/fish/config.fish
end
