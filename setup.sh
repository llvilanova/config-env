#!/bin/bash -e

BASE=$(dirname `readlink -f $0`)

echo "Setting up ~/.bashrc ..."
cat >$BASE/bashrc <<EOF
#!/bin/bash

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# always ask for confirmation
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'

alias grep='/bin/grep --color=auto'
alias less='/usr/bin/less -r'
EOF
touch ~/.bashrc
grep -v "^source .*/config-env/bashrc$" ~/.bashrc > ~/.bashrc.new
echo "source $BASE/bashrc" >> ~/.bashrc.new
mv ~/.bashrc.new ~/.bashrc
echo "Setting up ~/.bashrc ... done"


echo "Setting up ~/.inputrc ..."
cat >$BASE/inputrc <<EOF
\$include /etc/inputrc

\$if mode=emacs

# mappings for "page up" and "page down" to step to the beginning/end
# of the history
# "\e[5~": beginning-of-history
# "\e[6~": end-of-history

# alternate mappings for "page up" and "page down" to search the history
#"\e[5~": history-search-backward
#"\e[6~": history-search-forward

\$endif


\$if Bash
# alternate mappings for "up" and "down" to search the history
"\e[A": history-search-backward
"\e[B": history-search-forward
\$endif

\$if gdb
# alternate mappings for "up" and "down" to search the history
"\e[A": history-search-backward
"\e[B": history-search-forward
\$endif

\$if rlwrap
# alternate mappings for "up" and "down" to search the history
"\e[A": history-search-backward
"\e[B": history-search-forward
\$endif
EOF
touch ~/.inputrc
echo "\$include $BASE/inputrc" > ~/.inputrc.new
(grep -v '^\$include .*/config-env/inputrc$' ~/.inputrc >> ~/.inputrc.new) || true
mv ~/.inputrc.new ~/.inputrc
echo "Setting up ~/.inputrc ... done"


echo "Setting up ~/.gdbinit ..."
cat >$BASE/gdbinit <<EOF
set history filename ~/.cache/gdb_history
set history save on

set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

set schedule-multiple on
set scheduler-locking step

# gdb implementation of the linux lsmod
define lsmod
    set $current = modules.next
    set $offset =  ((int)&((struct module *)0).list)
    printf "Module\tAddress\n"

    while($current.next != modules.next)
        printf "%s\t%p\n",  \
        ((struct module *) (((void *) ($current)) - $offset ) )->name ,\
        ((struct module *) (((void *) ($current)) - $offset ) )->module_core
        set $current = $current.next
    end
end
EOF
mkdir -p $HOME/.config
touch ~/.gdbinit
echo "source $BASE/gdbinit" > ~/.gdbinit.new
grep -v "^source .*/config-env/gdbinit$" ~/.gdbinit >> ~/.gdbinit.new
mv ~/.gdbinit.new ~/.gdbinit
echo "Setting up ~/.gdbinit ... done"
