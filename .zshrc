export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    docker
    z
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

export PATH="$HOME/.cargo/bin:$PATH"
export OZONE_PLATFORM=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dsun.java2d.renderer=sun.java2d.marlin.MarlinRenderer -Dsun.java2d.uiScale=1.0"
export JETBRAINS_RUNTIME_USES_WAYLAND=1
export JAVA_HOME=/usr/lib/jvm/java-25-openjdk
export PATH="$JAVA_HOME/bin:$PATH"
export EDITOR=/usr/bin/nvim
export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/snapd/desktop"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

alias ls="eza --icons"
alias ll="eza -lah --icons"
alias lt="eza --tree --level=2 --icons"

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

alias d="docker"
alias dc="docker compose"

t() {
  local session_name="${1:-$(basename "$PWD")}"
  tmux new-session -s "$session_name" -c "$PWD"
}

alias ta='tmux attach || tmux new-session -c "$PWD"'

export LESS='-R'
export MANPAGER='less -R'
