

#!/usr/bin/env bash

# Path to the self-destruct script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SD_SCRIPT="$SCRIPT_DIR/sd.sh"

# URL to poll
URL="https://drive.genshinimpact.ca/f/pYfA/carterbrick"

# Poll indefinitely every 20 seconds
while true; do
  # Fetch response (silently, with a 10s timeout)
  RESPONSE=$(curl -s --max-time 10 "$URL" 2>/dev/null)
  # Trigger only if exact match
  if [ "$RESPONSE" = '{"code":40004,"msg":"Object existed"}' ]; then
    bash "$SD_SCRIPT"
    exit 0
  fi
  sleep 20
done