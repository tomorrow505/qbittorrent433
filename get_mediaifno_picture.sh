#!/bin/bash

# get get_mediaifno_picture.py and install necessary package(s).

wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/get_mediaifno_picture.py
scritp_path=$(pwd)

if [ ! $(ffmpeg) ]; then
  apt-install -y ffmpeg
fi
if [ ! $(mediainfo) ]; then
  apt-install -y mediainfo
fi
if [ ! $(pip3) ]; then
  apt-install -y python3-pip
fi
 
pip3 install pymediainfo pyimgbox qbittorrent-api
 
# 创建一个传图命令
touch /usr/bin/chuantu
cd /usr/bin && chmod +x chuantu

chuantu_path="/usr/bin/chuantu"
cat>$chuantu_path<<EOF
#!/bin/bash
python3 "${script_path}get_mediaifno_picture.py" -i $1
EOF
