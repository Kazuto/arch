# ZSH Environment Variables
# Loaded before .zshrc

# Editor and Terminal
export EDITOR="nvim"
export TERM="ghostty"
export TERMINAL="ghostty"

# Project paths
export PROJECT_ROOT="$HOME/Development"

# Nvim
export NVIM_LARAVEL_ENV="local"

# LM Studio
export LMSTUDIO_BASE_URL="http://localhost:1234"

# Anthropic API
export ANTHROPIC_MODEL="claude-sonnet-4-5-20250929"

# Development tools
export PYENV_ROOT="$HOME/.pyenv"
export TMUXIFIER_LAYOUT_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/tmuxifier/layouts"
export NVM_DIR="$HOME/.nvm"

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.spicetify:$PATH"
