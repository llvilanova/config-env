# flatpak apps visible to desktop GUI
if [ -f /etc/profile.d/flatpak.sh ]; then
  source /etc/profile.d/flatpak.sh
fi

#export PYTHONPATH=$PYTHONPATH:~/.local/lib/python3.8/site-packages/
export PATH=~/.local/bin:$PATH


##################################################
# ssh-agent
agent_env=~/.ssh/agent.env

agent_load_env () { test -f "$agent_env" && . "$agent_env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$agent_env")
    . "$agent_env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    agent_run_state=1
fi

if [ $agent_run_state = 1 ]; then
    if [ -t 0 ]; then
        ssh-add
        ssh-add ~/.ssh/*-id_rsa
    else
        # No terminal to answer a passphrase prompt on (e.g. GDM sources this
        # through the login shell with stdin=/dev/null, before gnome-session
        # starts). A prompt would block the whole session with a black screen,
        # so only load passphrase-less keys here; the rest are added on first
        # use via AddKeysToAgent in ~/.ssh/config.
        SSH_ASKPASS=/bin/false SSH_ASKPASS_REQUIRE=force ssh-add
        SSH_ASKPASS=/bin/false SSH_ASKPASS_REQUIRE=force ssh-add ~/.ssh/*-id_rsa
    fi
fi

unset agent_env
