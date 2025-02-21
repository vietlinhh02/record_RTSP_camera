#!/bin/bash
# Kiểm tra thư mục tạo chưa
directory="/etc/record/camera"
date=$(date +\%d-\%m-\%Y)
path="$directory/$date"

# Check if the directory exists
if [ ! -d "$path" ]; then
    # If the directory does not exist, create it
    mkdir -p "$path"
    echo "Directory created: $path"
else
    echo "Directory already exists: $path"
fi

# Chờ 3s và bắt đầu record video trong tầm 1h, vị trí lưu video trong /etc/record/camera
sleep 3

# Ghi hình sử dụng giao thức TCP thay vì UDP
sudo ffmpeg -rtsp_transport tcp -i rtsp://user:pass@tenmiendns:port/profile0 -vcodec copy -r 60 -t 3580 -y "$path/$(date +\%d-\%m-\%Y--\%H-\%M).mp4"
