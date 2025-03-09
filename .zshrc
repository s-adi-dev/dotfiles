#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#
# -----------------------------------------------------
# By Aditya
# -----------------------------------------------------

# Global Exports
export EDITOR=nvim

# A path .zsh file that stores the temporary zshrc config for the device
TempZshConfig="${HOME}/temp.zsh"

# If the TempZshConfig exists, the .zshrc will include that config to the main file
if [ -f "${TempZshConfig}" ]; then
    source "${TempZshConfig}"
fi

# Set the directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "${ZINIT_HOME}" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Enable true color support in the terminal for better color rendering
export COLORTERM=truecolor

# Setting up terminal prompt to oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Sourcing kitty.sh for dynamic kitty configurations
source ~/.config/kitty/kitty.sh

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice wait"0" # Loads these plugins after the prompt is set up.

# Load zsh-completions
autoload -U compinit && compinit -C

# Keybindings
bindkey -e
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# History
HISTSIZE=3000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Variables
bat='bat'
theme='Catppuccin Mocha'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -F -A --icons --color=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -F -A --icons --color=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview '\
if [[ -d "$realpath" ]]; then \
  eza -F -A --icons --color=always --group-directories-first "$realpath"; \
else \
  '"${bat}"' --theme="'"${theme}"'" --color=always "$realpath"; \
    fi'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias cat='${bat} --theme="${theme}"'
alias bat='${bat} --theme="${theme}"'
alias fzf='fzf --preview="${bat} --theme=\"${theme}\" --color=always {}"'
alias fnvim='nvim $(fzf -m --preview="${bat} --theme=\"${theme}\" --color=always {}")'

#--installer alias
AurHelper="yay"
alias s="${AurHelper} -Ss"
alias i="${AurHelper} -S"
alias si="${AurHelper} -Sy && ${AurHelper} -S"
alias r="${AurHelper} -Rns"
alias q="${AurHelper} -Q"

#--file alias
alias l='eza -F --icons --color=always --group-directories-first'
alias ld='eza -D -F --icons --color=always --group-directories-first'
alias lf='eza -f -F --icons --color=always --group-directories-first'
alias la='eza -a -F --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'
alias ln="ln -s"

# Functions
lt() {
    if [[ $1 =~ ^- ]]; then
        eza --icons --color=always --group-directories-first -T --level 1 "$@"
    else
        local level=${1:-1}  # Default to level 1 if no argument is provided
        shift                # Remove the first argument if supplied
        eza --icons --color=always --group-directories-first -T --level "$level" "$@"
    fi
}


# Shell integrations
# --zsh options are only available in fzf 0.48.0 or later.
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
