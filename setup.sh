#!/bin/bash -e

BASE=$(dirname `readlink -f $0`)

echo "Creating directories ..."
mkdir -p ~/bin
echo "Creating directories ... done"

echo "Setting up ~/.profile ..."
touch ~/.profile
grep -v "^source .*/config-env/profile$" ~/.profile > ~/.profile.new
echo "source $BASE/profile" >> ~/.profile.new
mv ~/.profile.new ~/.profile
echo "Setting up ~/.profile ... done"

echo "Setting up ~/.bashrc ..."
touch ~/.bashrc
grep -v "^source .*/config-env/bashrc$" ~/.bashrc > ~/.bashrc.new
echo "source $BASE/bashrc" >> ~/.bashrc.new
mv ~/.bashrc.new ~/.bashrc
echo "Setting up ~/.bashrc ... done"


echo "Setting up ~/.inputrc ..."
touch ~/.inputrc
(grep -v '^\$include .*/config-env/inputrc$' ~/.inputrc >> ~/.inputrc.new) || true
echo "\$include $BASE/inputrc" > ~/.inputrc.new
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
(grep -v "^source .*/config-env/gdbinit$" ~/.gdbinit >> ~/.gdbinit.new) || true
mv ~/.gdbinit.new ~/.gdbinit
echo "Setting up ~/.gdbinit ... done"
