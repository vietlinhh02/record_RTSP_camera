#!/usr/bin/env bash
set -euo pipefail

RECORD_DIR="${RECORD_DIR:-/etc/record/camera}"
RCLONE_REMOTE="${RCLONE_REMOTE:-cam}"
RCLONE_FOLDER="${RCLONE_FOLDER:-camera}"
YESTERDAY=$(date +%d-%m-%Y --date='yesterday')
YESTERDAY_DIR="$RECORD_DIR/$YESTERDAY"

if [[ ! -d "$YESTERDAY_DIR" ]]; then
    echo "No recordings found for $YESTERDAY, skipping."
    exit 0
fi

echo "Syncing $YESTERDAY_DIR to $RCLONE_REMOTE:$RCLONE_FOLDER/$YESTERDAY"
rclone sync "$YESTERDAY_DIR/" \
    "$RCLONE_REMOTE:$RCLONE_FOLDER/$YESTERDAY" \
    --auto-confirm --check-first -c

echo "Sync complete. Waiting 1h before cleanup..."
sleep 1h

echo "Removing $YESTERDAY_DIR"
rm -rf "$YESTERDAY_DIR"
echo "Cleanup done."
