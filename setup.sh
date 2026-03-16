#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/vietlinhh02/record_RTSP_camera/main"
RECORD_DIR="/etc/record"

echo "=== RTSP Camera Recording Setup ==="

# Cài đặt package
echo "[1/5] Installing packages..."
sudo apt update -y
sudo apt install -y curl unzip wget ffmpeg rclone

# Đặt múi giờ
echo "[2/5] Setting timezone to Asia/Ho_Chi_Minh..."
sudo timedatectl set-timezone Asia/Ho_Chi_Minh 2>/dev/null \
    || sudo ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Tạo thư mục
echo "[3/5] Creating directories..."
sudo mkdir -p "$RECORD_DIR/camera"

# Tải scripts
echo "[4/5] Downloading scripts..."
sudo wget -q -O "$RECORD_DIR/record.sh" "$REPO_URL/record/record.sh"
sudo wget -q -O "$RECORD_DIR/rclone.sh" "$REPO_URL/record/rclone.sh"
sudo chmod 755 "$RECORD_DIR/record.sh" "$RECORD_DIR/rclone.sh"

# Tạo config mẫu nếu chưa có
if [[ ! -f "$RECORD_DIR/record.conf" ]]; then
    sudo wget -q -O "$RECORD_DIR/record.conf" "$REPO_URL/record/record.conf.example"
    echo "Config file created at $RECORD_DIR/record.conf — please edit it!"
fi

# Cài crontab
echo "[5/5] Setting up crontab..."
CRON_RECORD="0 * * * * $RECORD_DIR/record.sh"
CRON_RCLONE="0 0 * * * $RECORD_DIR/rclone.sh"

existing_cron=$(crontab -l 2>/dev/null || true)
new_cron="$existing_cron"

if ! echo "$existing_cron" | grep -qF "$RECORD_DIR/record.sh"; then
    new_cron="$new_cron
$CRON_RECORD"
fi
if ! echo "$existing_cron" | grep -qF "$RECORD_DIR/rclone.sh"; then
    new_cron="$new_cron
$CRON_RCLONE"
fi

echo "$new_cron" | crontab -

echo ""
echo "=== Setup complete! ==="
echo "Next steps:"
echo "  1. Edit $RECORD_DIR/record.conf with your RTSP camera URL"
echo "  2. Configure rclone: rclone config"
echo "  3. Test recording: $RECORD_DIR/record.sh"
