#!/usr/bin/env bash

# Cập nhật hệ thống và cài đặt các package cần thiết
sudo apt update -y
sudo apt install -y ntpdate curl unzip wget software-properties-common ffmpeg rclone

# Đặt múi giờ về Asia/Ho_Chi_Minh
sudo ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Cập nhật thời gian hệ thống từ NTP
sudo ntpdate vn.pool.ntp.org

# Tạo thư mục và thiết lập quyền
sudo mkdir -p /etc/record/camera
sudo chmod -R 777 /etc/record

# Tải file cấu hình
sudo wget --no-check-certificate -P /etc/record/ "https://raw.githubusercontent.com/duchoa23/record_RTSP_camera/main/record/rclone.sh"
sudo wget --no-check-certificate -P /etc/record/ "https://raw.githubusercontent.com/duchoa23/record_RTSP_camera/main/record/record.sh"
sudo chmod -R 777 /etc/record/record.sh
sudo chmod -R 777 /etc/record/rclone.sh

# Tạo crontab
cron_job="0 * * * * /etc/record/record.sh"
cron_job2="0 0 * * * /etc/record/rclone.sh"

# Thêm cron job nếu chưa có
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -
(crontab -l 2>/dev/null; echo "$cron_job2") | crontab -
