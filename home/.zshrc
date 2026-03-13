# ZSH Configuration
# Generated from modules/home/cli/zsh/default.nix

# Enable Powerlevel10k instant prompt (optional, using Starship instead)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Oh-My-Zsh plugins
plugins=(git composer npm zsh-autosuggestions)

# Initialize completion system
autoload -Uz compinit
compinit

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Zsh syntax highlighting (must load AFTER oh-my-zsh)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestion accept keys
bindkey '^ ' autosuggest-accept  # Ctrl+Space accepts suggestion
bindkey '^[[Z' autosuggest-accept # Shift+Tab accepts suggestion

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

# Load aliases
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.aliases" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.aliases"

# Key bindings
bindkey "^[[3~" delete-char              # Delete key
bindkey "^[[H" beginning-of-line         # Home key
bindkey "^[[F" end-of-line               # End key
bindkey "^[[1;5C" forward-word           # Ctrl+Right
bindkey "^[[1;5D" backward-word          # Ctrl+Left
bindkey "^?" backward-delete-char        # Backspace

# Load custom functions
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.functions" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.functions"

# Load tool initializations (includes starship)
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.init" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.init"

# Source additional config files (if they exist)
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.after" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.after"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
