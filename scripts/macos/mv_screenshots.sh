#!/opt/homebrew/bin/bash
set -euo pipefail

HOME="/Users/jared/"
SOURCE_DIR="$HOME/Desktop"
DEST_DIR="$HOME/Documents/screenshots"
LOG_FILE="/var/log/cron/jared/mv_screenshots.log"

mkdir -p "$(dirname "$DEST_DIR")"
mkdir -p "$(dirname "$LOG_FILE")"

{
    timestamp="$(date +%Y-%m-%dT%H:%M:%S%z)"
    echo -n "$timestamp"

    mapfile -t png_files < <(/opt/homebrew/bin/fd --glob '*.png' "$SOURCE_DIR")

    if [ "${#png_files[@]}" -eq 0 ]; then
        echo "$timestamp no files to move"
    else
        mv "${png_files[@]}" "$DEST_DIR/" 2>&1
        echo " moved ${#png_files[@]} file(s)"
    fi
} 2>&1 | tee -a "$LOG_FILE"
