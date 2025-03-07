fish_vi_key_bindings
set fish_greeting

set -Ux  GIT_EDITOR "nvim"
set -Ux  EDITOR "nvim"

alias v='nvim'
alias vv='/usr/local/bin/nvim'
alias vit='git diff --name-only master | xargs /usr/local/bin/nvim -p'
alias cat='bat'
alias x="exit"
alias gg="lazygit"
alias c="clear"


alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dl="docker logs -f"
alias activate="source venv/bin/activate.fish"

pyenv init - fish | source
zoxide init fish | source

function config
	v ~/.config/fish/config.fish
end

function reload 
	source ~/.config/fish/config.fish
end
