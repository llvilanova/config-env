# flatpak apps visible to desktop GUI
if [ -f /etc/profile.d/flatpak.sh ]; then
  source /etc/profile.d/flatpak.sh
fi

# touch-scroll in firefox
export MOZ_USE_XINPUT2=1
