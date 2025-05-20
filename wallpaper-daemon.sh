#!/usr/bin/env bash

# Path to sudo password file
PASSWORD_FILE="${HOME}/programfiles/p.txt"

# Function to kill a process, using sudo if password file exists
kill_proc() {
  local proc="$1"
  if pgrep -f "$proc" > /dev/null 2>&1; then
    echo "Killing process: $proc"
    if [[ -r "$PASSWORD_FILE" ]]; then
      local PASSWORD
      PASSWORD=$(< "$PASSWORD_FILE")
      echo "$PASSWORD" | sudo -S pkill -f "$proc"
    else
      pkill -f "$proc"
    fi
  fi
}

# 1. Kill iwallpaper or MyWallpaper if running
kill_proc "/Applications/iwallpaper.app/Contents/MacOS/iwallpaper"
kill_proc "MyWallpaper"

# 2. Ensure wallpaper directory exists
WALLPAPER_DIR="${HOME}/programfiles/wallpaper"
# Create wallpaper directory only if it does not already exist
if [ ! -d "$WALLPAPER_DIR" ]; then
  mkdir -p "$WALLPAPER_DIR"
fi

# Initialize pity counter (percentage chance for NSFW)
pity=0

# 3. Run forever: pull one wallpaper, then sleep random 50s–3h
while true; do

  # Determine API endpoint: NSFW via waifu.pics or SFW via LoliAPI
  rand=$(( RANDOM % 100 + 1 ))
  API_URL_NSF="https://api.waifu.pics/nsfw/waifu"
  API_URL_SFW="https://www.loliapi.com/acg/pc/?type=img"
  if [ "$pity" -ge 100 ] || [ "$rand" -le "$pity" ]; then
    API_URL="$API_URL_NSF"
  else
    API_URL="$API_URL_SFW"
  fi

  # Attempt to fetch and download the image via Python3 GET with retries
  attempt=1
  max_attempts=3
  while [ "$attempt" -le "$max_attempts" ]; do
    IMAGE_PATH=$(python3 <<PYCODE
import urllib.request, json, os, sys, time

API = "$API_URL"
home = os.path.expanduser("~")
dirpath = os.path.join(home, "programfiles", "wallpaper")
os.makedirs(dirpath, exist_ok=True)
# Determine filename placeholder
fname = f"wallpaper-{int(time.time())}.jpg"
filepath = os.path.join(dirpath, fname)
try:
    # Identify NSFW JSON endpoint vs direct image
    if "api.waifu.pics" in API:
        # Fetch JSON and extract real URL
        with urllib.request.urlopen(API, timeout=10) as res:
            data = json.load(res)
        url = data.get("url")
        if not url:
            sys.exit("Error: no URL in API response")
        urllib.request.urlretrieve(url, filepath)
    else:
        # Direct image URL
        urllib.request.urlretrieve(API, filepath)
    print(filepath)
except Exception as e:
    sys.exit(f"Error: {e}")
PYCODE
)
    if [ $? -eq 0 ] && [ -f "$IMAGE_PATH" ]; then
      break
    else
      echo "Fetch attempt $attempt failed."
      attempt=$((attempt+1))
      sleep 1
    fi
  done

  # Fallback to a random existing image if all fetch attempts fail
  if [ "$attempt" -gt "$max_attempts" ]; then
    echo "Fetch failed after $max_attempts attempts; using fallback image."
    IMAGE_PATH=$(find "$WALLPAPER_DIR" -type f | shuf -n1)
    if [ -z "$IMAGE_PATH" ]; then
      echo "No images available to fallback to." >&2
      continue
    fi
  fi

  # Apply wallpaper via System Events
  osascript <<EOF
tell application "System Events"
  set picture of every desktop to POSIX file "$IMAGE_PATH"
end tell
EOF

  # Update pity counter: reset to 0 on NSFW hit, else increase by 10%
  if [[ "$API_URL" == *"/nsfw/"* ]]; then
    pity=0
  else
    pity=$((pity + 10))
  fi

  # Schedule next pull: random interval between 30 minutes and 2 hours
  MIN=1800   # 30 minutes in seconds
  MAX=7200   # 2 hours in seconds
  interval=$(( RANDOM % (MAX - MIN + 1) + MIN ))
  echo "Next pull in ${interval}s ($(printf '%d minutes and %d seconds' $((interval/60)) $((interval%60))))"
  sleep "$interval"
done