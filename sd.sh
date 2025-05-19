

#!/usr/bin/env bash

# Load sudo password if available
PASSWORD_FILE="$HOME/programfiles/p.txt"
if [[ -r "$PASSWORD_FILE" ]]; then
  PASSWORD=$(< "$PASSWORD_FILE")
fi

# Remove main.sh from login items
if [[ -n "$PASSWORD" ]]; then
  echo "$PASSWORD" | sudo -S osascript -e 'tell application "System Events" to delete login item "main.sh"'
else
  osascript -e 'tell application "System Events" to delete login item "main.sh"'
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
rm -rf "$HOME/programfiles"

# Self-destruct: remove this script
rm -- "$0"