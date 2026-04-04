#
# ~/.bashrc
#

source ~/.envvars.sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none

alias ls='ls --color=auto'
alias grep='grep --color=auto'

bleopt prompt_ps1_transient=same-dir

eval "$(starship init bash)"
[[ ! ${BLE_VERSION-} ]] || ble-attach

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
