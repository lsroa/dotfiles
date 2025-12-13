fish_vi_key_bindings
set fish_greeting

alias v='nvim'
set -Ux  GIT_EDITOR "nvim"
set -Ux  EDITOR "nvim"

set -Ux XDG_CONFIG_HOME "$HOME/.config"
alias cat='bat'
alias x="exit"
alias gg="lazygit"
alias c="clear"


alias dcu="docker compose up"
alias dcd="docker compose down"
alias dl="docker logs -f"

function go
  if not git checkout $argv[1]
    git fetch origin $argv[1] && git checkout $args
  end
end

function activate
  if test -e "venv"
    source "./venv/bin/activate.fish"
  end

  if test -e ".venv"
    source "./.venv/bin/activate.fish"
  end
end

pyenv init - fish | source
zoxide init fish | source

function config
	v ~/.config/fish/config.fish
end

function reload 
	source ~/.config/fish/config.fish
end

function gen_uuid
  uuidgen | string lower | tr -d '\n' | pbcopy
end

source ~/.invoke-completion.sh

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
