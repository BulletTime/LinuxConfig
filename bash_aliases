#
# ~/.bash_aliases
#

# ls
alias ls='ls --color=auto'
alias ll='ls -lah'
alias l.='ll -d .*'

# tree
alias tree='tree -C -L 2'

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# diff
alias diff='colordiff'

# mount
alias mount='mount | column -t'

# du
alias du='du -h --all --max-depth=1 | sort -h -r'
