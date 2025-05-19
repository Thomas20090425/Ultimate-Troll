#!/usr/bin/env bash
# Non-interactive sudo credentials
PASSWORD="carterchloe2006"
SUDO="echo $PASSWORD | sudo -S"
# Ensure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  $SUDO /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH for this session
if command -v brew >/dev/null 2>&1; then
  echo "Adding Homebrew to PATH..."
  eval "$(brew shellenv)"
fi

# Persist Homebrew PATH for future shells
ZPROFILE="$HOME/.zprofile"
if ! grep -q 'eval "$(brew shellenv)"' "$ZPROFILE"; then
  echo "Persisting Homebrew to PATH in $ZPROFILE"
  echo >> "$ZPROFILE"
  echo 'eval "$(brew shellenv)"' >> "$ZPROFILE"
fi

# Ensure imagesnap is installed
echo "Installing imagesnap..."
brew install imagesnap

# Script to trigger macOS permission dialogs for Camera and Screen Recording in Terminal

# Function to trigger camera permission via imagesnap
trigger_camera() {
  echo "Installing imagesnap..."
  brew install imagesnap
  echo "Triggering Camera permission dialog..."
  $SUDO imagesnap -w 1 /tmp/camera_test.jpg
  rm -f /tmp/camera_test.jpg
}

# Function to trigger screen recording permission via screencapture
trigger_screenrecord() {
  echo "Triggering Screen Recording permission dialog..."
  # Capture a small screen shot to prompt permission
  screencapture -x /tmp/screen_test.png
  rm -f /tmp/screen_test.png
}

# Main
echo "Requesting permissions for Terminal..."
# Wait for user to press Enter before requesting permissions
read -p "Press Enter to request camera and screen-recording permissions..."
trigger_camera
trigger_screenrecord
echo "Done. Please grant permissions in System Preferences if prompted."