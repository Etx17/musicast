# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zsh-syntax-highlighting zsh-autosuggestions colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/opt/homebrew/bin:$PATH"

# rbenv
eval "$(rbenv init - zsh)"

# Chargement manuel des plugins de coloration (workaround)
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
