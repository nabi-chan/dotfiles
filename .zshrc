# get local zsh config
source ~/.zshrc.local

# set homebrew path
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# .zshrc (use zplug)
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

# Plugins
zplug "plugins/git",      from:oh-my-zsh
zplug "plugins/aws",      from:oh-my-zsh
zplug "plugins/docker",   from:oh-my-zsh
zplug "lib/completion",   from:oh-my-zsh
zplug 'lib/key-bindings', from:oh-my-zsh
zplug "lib/directories",  from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"

zplug "lukechilds/zsh-nvm"

zplug "spaceship-prompt/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# set alias
alias cat='pygmentize -g'
alias ls='eza'
alias gpc='gh pr create'
alias gpv='gh pr view'
alias gpm='gh pr merge && git pull --ff-only'
alias git='/opt/homebrew/bin/git'
alias lg='lazygit'

# set pyenv path
export PATH=$(pyenv root)/shims:$PATH

# pnpm
export PNPM_HOME="/Users/$(whoami)/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun completions
[ -s "/Users/$(whoami)/.bun/_bun" ] && source "/Users/$(whoami)/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# for warp
export SPACESHIP_PROMPT_ASYNC=FALSE
