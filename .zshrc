# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Starship provides the prompt, so don't load an Oh My Zsh theme.
ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    docker
    docker-compose
    z
    thefuck
)

source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# User configuration

export PATH="$HOME/.cargo/bin:$PATH"

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Force IntelliJ to use Wayland instead of XWayland
export OZONE_PLATFORM=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# Ensure Java apps don't show that white title bar (Client Side Decorations)
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dsun.java2d.renderer=sun.java2d.marlin.MarlinRenderer -Dsun.java2d.uiScale=1.0"

# Fix for JetBrains specifically to use Wayland
export JETBRAINS_RUNTIME_USES_WAYLAND=1

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export GOOGLE_CLOUD_PROJECT="gen-lang-client-0199965123"

export JAVA_HOME=/usr/lib/jvm/java-25-openjdk
export PATH="$JAVA_HOME/bin:$PATH"

export EDITOR=/usr/bin/nvim

export PATH="$HOME/.local/bin:$PATH"

export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/snapd/desktop"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
