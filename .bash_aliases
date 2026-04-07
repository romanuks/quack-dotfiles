alias ls='ls --color=auto'
alias grep='grep --color=auto'

# calculate time difference
alias tm='f(){ datediff -f "%H:%M" $(date "+%Y-%m-%dT$1:$2:00") $(date "+%Y-%m-%dT%H:%M:%S"); }; f'
