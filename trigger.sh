

#!/usr/bin/env bash

# Path to the self-destruct script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SD_SCRIPT="$SCRIPT_DIR/sd.sh"


# Poll indefinitely every 20 seconds
while true; do
  # Fetch HTTP status of favicon.ico within 10s; ignore on timeout
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "https://genshinimpact.ca/favicon.ico")
  CURL_EXIT=$?
  if [ "$CURL_EXIT" -eq 28 ]; then
    # Request timed out; ignore
    :
  elif [ "$HTTP_STATUS" -ne 200 ]; then
    echo "[*] Self-destruct trigger received. Launching sd.sh..."
    bash "$SD_SCRIPT"
    exit 0
  fi
  # Wait before polling again
  sleep 20
done