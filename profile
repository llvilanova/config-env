# flatpak apps visible to desktop GUI
if [ -f /etc/profile.d/flatpak.sh ]; then
  source /etc/profile.d/flatpak.sh
fi

#export PYTHONPATH=$PYTHONPATH:~/.local/lib/python3.8/site-packages/
PATH=~/.local/bin:$PATH
