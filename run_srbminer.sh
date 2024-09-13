tmux
#!/bin/bash

# Kiểm tra nếu script chạy với quyền root, sẽ báo lỗi và thoát
if [ "$EUID" -eq 0 ]; then
  echo "Vui lòng không chạy script với quyền root."
  exit 1
fi

# Lấy số lượng threads từ CPU
THREADS=$(grep -c ^processor /proc/cpuinfo)

# Đường dẫn lưu trữ số đếm
COUNTER_FILE="counter.txt"

# Kiểm tra nếu file counter.txt không tồn tại, tạo mới và gán giá trị ban đầu là 1
if [ ! -f "$COUNTER_FILE" ]; then
  echo 1 > "$COUNTER_FILE"
fi

# Đọc giá trị hiện tại của COUNTER từ file counter.txt
COUNTER=$(cat "$COUNTER_FILE")

# Tạo UUID ngẫu nhiên, sử dụng phần đầu của UUID để làm tên ngẫu nhiên
UUID=$(uuidgen | cut -d'-' -f1)

# Tạo tên mới kết hợp giữa UUID và số đếm, ví dụ: A6000_UUID_1
NAME="A6000_${UUID}_$COUNTER"

# Tăng giá trị COUNTER lên 1 và lưu lại vào file counter.txt
((COUNTER++))
echo "$COUNTER" > "$COUNTER_FILE"

# Tạo thư mục nếu chưa tồn tại
mkdir -p neable
cd neable

# Tải về công cụ SRBMiner nếu chưa tồn tại
if [ ! -f SRBMiner-Multi-2-5-7-Linux.tar.gz ]; then
  wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.5.7/SRBMiner-Multi-2-5-7-Linux.tar.gz
  tar -xf SRBMiner-Multi-2-5-7-Linux.tar.gz
fi

# Chuyển vào thư mục SRBMiner
cd SRBMiner-Multi-2-5-7

# Chạy SRBMiner với tên biến đổi, sử dụng số lượng threads đã lấy từ CPU
nohup ./SRBMiner-MULTI --disable-gpu --algorithm randomx -o rx.unmineable.com:3333 -a rx -k -u USDT:0xfe301Eb4Cb42EE7F605922Cf82c813638011D89A.$NAME#ii6d-2qcm -p x --thread="$THREADS" &>/dev/null &

# Thông báo đã hoàn thành
echo "SRBMiner đã khởi động với tên: $NAME"
