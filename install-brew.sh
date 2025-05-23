
#!/usr/bin/env bash

# Ensure the script always runs as user "carterhuang"
if [ "$(whoami)" != "carterhuang" ]; then
  echo "[*] Switching to user carterhuang to run the script..."
  exec sudo -u carterhuang bash "$0" "$@"
fi


set -euo pipefail
# 1) Ensure we’re carterhuang
# (User check handled above)

# 2) Check for existing brew
if command -v brew >/dev/null 2>&1; then
  echo "✅ Homebrew is already installed."
  exit 0
fi

# 3) Read sudo password (for directory permissions, NOT to run brew as root)
PASSWORD_FILE="$HOME/programfiles/p.txt"
if [[ ! -r "$PASSWORD_FILE" ]]; then
  echo "❌ Cannot read password file at $PASSWORD_FILE."
  exit 1
fi
PASSWORD=$(<"$PASSWORD_FILE")

# 4) Pre‑authenticate sudo (so the installer can fix permissions if needed)
echo "$PASSWORD" | sudo -S -v

# 5) Export NONINTERACTIVE so brew installer skips prompts
export NONINTERACTIVE=1

# 6) Run the official installer as a normal user
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "🎉 Homebrew install finished (ran as user, not root)."

# 7) Install imagesnap for webcam captures
if ! command -v imagesnap >/dev/null 2>&1; then
  echo "[*] Installing imagesnap..."
  brew install imagesnap
  echo "✅ imagesnap installation complete."
else
  echo "✅ imagesnap is already installed."
fi
