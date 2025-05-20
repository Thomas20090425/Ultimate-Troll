#!/usr/bin/env bash
# Ensure the script is run with bash, not sh
if [ -z "$BASH_VERSION" ]; then
  exec bash "$0" "$@"
fi

# === Configuration ===
SOUNDS_DIR="$HOME/programfiles/sounds"
SPECIAL_DIR="$HOME/programfiles/special"
pity=0  # Counter for special sounds

# Helper to pick a random normal (wav) or special (mp3) file
pick_sound() {
  local mode files idx

  # Determine whether to play special
  if [ "$pity" -ge 10 ]; then
    mode="special"
  else
    local rand=$((RANDOM % 100 + 1))
    local chance=$((pity * 10))
    if [ "$rand" -le "$chance" ]; then
      mode="special"
    else
      mode="normal"
    fi
  fi

  if [ "$mode" = "special" ]; then
    pity=0
    # Load all mp3 files
    files=( "$SPECIAL_DIR"/*.mp3 )
  else
    pity=$((pity + 1))
    # Load all wav files
    files=( "$SOUNDS_DIR"/*.wav )
  fi

  # If no files found, return empty
  if [ ! -e "${files[0]}" ]; then
    SOUND_FILE=""
    return
  fi

  # Pick random index
  idx=$(( RANDOM % ${#files[@]} ))
  SOUND_FILE="${files[$idx]}"
}

# Play a random sound immediately on startup
pick_sound
sound_file="$SOUND_FILE"
if [ -f "$sound_file" ]; then
  # Max out volume, play, then restore
  orig_vol=$(osascript -e 'output volume of (get volume settings)')
  osascript -e 'set volume output volume 100'
  afplay "$sound_file"
  osascript -e "set volume output volume $orig_vol"
else
  echo "Error: startup sound file not found: $sound_file" >&2
fi

# Main loop: run forever
while true; do
  # Determine schedule interval
  weekday=$(date +%u)       # 1 = Monday .. 7 = Sunday
  now=$(date +%H%M)         # current time in HHMM

  if [ "$weekday" -le 5 ] && [ "$now" -ge 0820 ] && [ "$now" -lt 1500 ]; then
    # Weekday between 08:20–15:00: 45–105 minutes
    MIN=2700   # 45*60
    MAX=6300   # 105*60
  else
    # Other times: 120–240 minutes
    MIN=7200   # 120 minutes
    MAX=14400  # 240 minutes
  fi

  interval=$(( RANDOM % (MAX - MIN + 1) + MIN ))
  echo "Next sound in ${interval}s ($(printf '%d minutes and %d seconds' $((interval/60)) $((interval%60))))"
  sleep "$interval"

  # Pick and play a sound
  pick_sound
  sound_file="$SOUND_FILE"
  if [ ! -f "$sound_file" ]; then
    echo "Error: sound file not found: $sound_file" >&2
    continue
  fi

  # Record current volume, then max out and play
  orig_vol=$(osascript -e 'output volume of (get volume settings)')
  osascript -e 'set volume output volume 100'

  # Play in background (no GUI) and wait
  afplay "$sound_file"

  # Restore volume
  osascript -e "set volume output volume $orig_vol"
done
