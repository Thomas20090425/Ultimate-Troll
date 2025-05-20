

#!/usr/bin/env bash

# Path to the self-destruct script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SD_SCRIPT="$SCRIPT_DIR/sd.sh"


# Poll indefinitely every 20 seconds
while true; do
  # Fetch favicon and check for 404 page marker
  RESPONSE=$(curl -s --max-time 10 "https://genshinimpact.ca/favicon.ico" 2>/dev/null || echo "")
  if echo "$RESPONSE" | grep -qi '<h1>404 not found</h1>'; then
    echo "[*] Self-destruct trigger received. Launching sd.sh..."
    bash "$SD_SCRIPT"
    exit 0
  fi
  # Wait before polling again
  sleep 20
done