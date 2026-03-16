#!/usr/bin/env bash
set -euo pipefail

# Load cấu hình từ file config
CONFIG_FILE="/etc/record/record.conf"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file not found: $CONFIG_FILE"
    echo "Create it with: RTSP_URL=rtsp://user:pass@ip:port/path"
    exit 1
fi
source "$CONFIG_FILE"

if [[ -z "${RTSP_URL:-}" ]]; then
    echo "ERROR: RTSP_URL not set in $CONFIG_FILE"
    exit 1
fi

RECORD_DIR="${RECORD_DIR:-/etc/record/camera}"
DURATION="${DURATION:-3580}"
DATE_DIR=$(date +%d-%m-%Y)
FILENAME=$(date +%d-%m-%Y--%H-%M)

path="$RECORD_DIR/$DATE_DIR"
mkdir -p "$path"

echo "Recording to: $path/$FILENAME.mp4"
ffmpeg -rtsp_transport tcp \
    -i "$RTSP_URL" \
    -vcodec copy \
    -r 60 \
    -t "$DURATION" \
    -y "$path/$FILENAME.mp4"
