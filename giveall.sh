#!/usr/bin/env bash
#
# prompt_permissions.sh
# Trigger & open all major Privacy‑&‑Security panes on macOS (excludes Screen Recording & Camera)

# 1) Full Disk Access (Documents, Desktop, etc)
echo "[*] Triggering Full Disk Access prompt…"
ls ~/Documents >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
sleep 1

# 2) Accessibility
echo "[*] Triggering Accessibility prompt…"
osascript -e 'tell application "System Events" to get the name of every process' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
sleep 1

# 3) Contacts
echo "[*] Triggering Contacts prompt…"
osascript -e 'tell application "Contacts" to get name of every person' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"
sleep 1

# 4) Calendars
echo "[*] Triggering Calendars prompt…"
osascript -e 'tell application "Calendar" to get name of calendars' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
sleep 1

# 5) Reminders
echo "[*] Triggering Reminders prompt…"
osascript -e 'tell application "Reminders" to get name of lists' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
sleep 1

# 6) Photos
echo "[*] Triggering Photos prompt…"
osascript -e 'tell application "Photos" to get name of albums' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Photos"
sleep 1

# 7) Microphone
echo "[*] Triggering Microphone prompt…"
# Using AppleScript to record 0s of audio to trigger the prompt
osascript -e 'set rec to (do shell script "afplay /System/Library/Sounds/Pop.aiff")' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
sleep 1

# 8) Developer Tools
echo "[*] Triggering Developer Tools prompt…"
osascript -e 'tell application "Terminal" to do script "echo Hello"' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_DeveloperTools"
sleep 1

# 9) Files and Folders (App-specific file‐system access on Big Sur+)
echo "[*] Triggering Files & Folders prompt…"
# Try reading your Desktop via a shell that hasn’t been allowed yet
/bin/zsh -c 'ls ~/Desktop >/dev/null' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_FilesAndFolders"
sleep 1

# 10) Location Services
echo "[*] Opening Location Services pane…"
# Trigger Location Services prompt
ls /var/db/locationd >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
sleep 1

# 11) Bluetooth
echo "[*] Opening Bluetooth pane…"
# Trigger Bluetooth prompt
system_profiler SPBluetoothDataType >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Bluetooth"
sleep 1

# 12) Speech Recognition 
echo "[*] Opening Speech Recognition pane…"
# Trigger Speech Recognition prompt
afplay /System/Library/Sounds/Pop.aiff >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition"
sleep 1

# 13) Input Monitoring
echo "[*] Opening Input Monitoring pane…"
# Trigger Input Monitoring prompt
osascript -e 'tell application "System Events" to keystroke "A"' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_InputMonitoring"
sleep 1

# 14) Automation
echo "[*] Opening Automation pane…"
# Trigger Automation prompt
osascript -e 'tell application "Safari" to get name of windows' >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
sleep 1

# 15) Analytics & Improvements
echo "[*] Opening Analytics & Improvements pane…"
# Trigger Analytics & Improvements prompt
defaults read /Library/Preferences/com.apple.analyticsd.plist >/dev/null 2>&1 || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Analytics"
sleep 1

echo
echo "→ All Privacy panes have been opened.  Please go through each pane and enable the apps/scripts you need."