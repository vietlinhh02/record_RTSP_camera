# RTSP Camera Recorder

Script tự động ghi hình từ camera RTSP và upload lên Cloud (Google Drive, OneDrive, Dropbox...) thông qua Rclone.

## Tính năng

- Ghi hình liên tục từ RTSP stream, mỗi file 1 giờ
- Tự động tổ chức file theo ngày (`/etc/record/camera/DD-MM-YYYY/`)
- Sync video lên cloud lúc 0h hàng ngày qua Rclone
- Tự động xóa file local sau khi upload thành công

## Yêu cầu

- VPS Linux (Ubuntu/Debian)
- Camera có RTSP stream và thông tin đăng nhập
- Tài khoản Cloud (Google Drive, OneDrive, Dropbox...)

## Cài đặt

### 1. Chạy script setup

```bash
curl -L https://raw.githubusercontent.com/vietlinhh02/record_RTSP_camera/main/setup.sh | sudo bash
```

Script sẽ tự động:
- Cài đặt ffmpeg, rclone và các package cần thiết
- Đặt timezone Asia/Ho_Chi_Minh
- Tạo thư mục `/etc/record/`
- Thiết lập crontab (ghi hình mỗi giờ, sync mỗi ngày)

### 2. Cấu hình RTSP camera

Chỉnh sửa file `/etc/record/record.conf`:

```bash
sudo nano /etc/record/record.conf
```

```ini
# URL RTSP camera (bắt buộc)
RTSP_URL="rtsp://user:password@192.168.1.100:554/cam/realmonitor?channel=1&subtype=0"

# Thời lượng mỗi file (giây), mặc định 3580 ~ 1h
DURATION="3580"
```

### 3. Cấu hình Rclone

```bash
rclone config
```

Tham khảo [tài liệu Rclone](https://rclone.org/docs/) để kết nối với cloud provider. Tên remote mặc định trong config là `cam`, thư mục cloud là `camera`.

### 4. Test thử

```bash
/etc/record/record.sh
```

## Cấu trúc thư mục

```
/etc/record/
├── record.sh          # Script ghi hình (chạy mỗi giờ)
├── rclone.sh          # Script sync cloud (chạy lúc 0h)
├── record.conf        # File cấu hình
└── camera/
    ├── 17-03-2026/
    │   ├── 17-03-2026--00-00.mp4
    │   ├── 17-03-2026--01-00.mp4
    │   └── ...
    └── 18-03-2026/
        └── ...
```

## Crontab

| Schedule | Script | Mô tả |
|----------|--------|-------|
| `0 * * * *` | `record.sh` | Ghi hình mỗi giờ |
| `0 0 * * *` | `rclone.sh` | Sync lên cloud lúc 0h, xóa file cũ sau 1h |

## License

MIT
