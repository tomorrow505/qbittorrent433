#!/bin/bash

# get get_mediaifno_picture.py and install necessary package(s).

wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/get_mediainfo_picture.py -O get_mediainfo_picture.py
scritp_path=$(pwd)
mkdir tmp && chmod 777 tmp

if ! [ -x "$(command -v ffmpeg)" ]; then
  apt -y install ffmpeg >/dev/null 2>&1
fi
if ! [ -x "$(command -v mediainfo)" ]; then
  apt -y install mediainfo >/dev/null 2>&1
fi
if ! [ -x "$(command -v pip3)" ]; then
  apt -y install python3-pip >/dev/null 2>&1
fi
 
pip3 install pymediainfo pyimgbox qbittorrent-api pillow
 
# 创建一个传图命令
if [ -f /usr/bin/chuantu ]; then
  echo "chuantu命令已经存在！！"
  exit 1
fi

touch /usr/bin/chuantu
cd /usr/bin && chmod +x chuantu
chuantu_path="/usr/bin/chuantu"
cat<<EOF>$chuantu_path
#!/bin/bash
python3 "${script_path}get_mediainfo_picture.py" -i \$1
EOF
