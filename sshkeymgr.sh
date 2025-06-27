#!/bin/bash

set -euo pipefail

# Default target path
TARGET="/root/.ssh/authorized_keys"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="$2"
      shift 2
      ;;
    *)
      PARAMS+=("$1")
      shift
      ;;
  esac
done

# Remaining required params: PLATFORMID and SERVERNAME
if [[ "${#PARAMS[@]:-}" -lt 2 ]]; then
  echo "Usage: $0 [--target /path/to/authorized_keys] PLATFORMID SERVERNAME"
  exit 1
fi

PLATFORMID="${PARAMS[0]}"
SERVERNAME="${PARAMS[1]}"

# Get directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYS_DIR="$SCRIPT_DIR/keys"

# Temporary file for atomic update
TMPFILE="$(mktemp)"

# Fetch keys from server
URL="https://cloud.zeyos.com/${PLATFORMID}/remotecall/sshkeys/${SERVERNAME}"
curl -fsSL "$URL" >> "$TMPFILE"

# Append valid local keys if available
if [[ -d "$KEYS_DIR" ]]; then
  for file in "$KEYS_DIR"/*; do
    if [[ -f "$file" ]] && grep -Eq '^(ssh-(rsa|ed25519)|ecdsa-sha2-nistp[0-9]+)' "$file"; then
      cat "$file" >> "$TMPFILE"
    fi
  done
fi

# Ensure .ssh directory exists
mkdir -p "$(dirname "$TARGET")"
chmod 700 "$(dirname "$TARGET")"

# Replace authorized_keys atomically
mv "$TMPFILE" "$TARGET"
chmod 600 "$TARGET"

exit 0
