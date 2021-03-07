#!/bin/bash
###################################环境准备#############################
version="$(cat /proc/version)"
ubuntu="Ubuntu"
result=$(echo $version | grep "${ubuntu}")
if [[ "$result" != "" ]]
then
    cp /etc/vim/vimrc ~/.vimrc
fi

###################################目录准备#############################
echo -n "输入你的用户名："
read name
lib_dir="/home/${name}/libtorrent"
qbit_dir="/home/${name}/qbittorrent"
boost_dir="/home/${name}/boost"
autoseed_dir="/home/${name}/Autoseed"

mkdir "/home/$name"
mkdir $lib_dir
mkdir $qbit_dir
mkdir $boost_dir
mkdir $autoseed_dir

cd $autoseed_dir && mkdir cache && chmod 777 cache
cd $autoseed_dir && mkdir tmp && chmod 777 tmp
cd $qbit_dir && mkdir torrent && mkdir download

# 安装rzsz
mkdir "/home/${name}/rzsz"
cd "/home/${name}/rzsz"
wget http://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz
tar zxvf lrzsz-0.12.20.tar.gz && cd lrzsz-0.12.20
./configure && make && make install
cd /usr/bin
ln -s /usr/local/bin/lrz rz
ln -s /usr/local/bin/lsz sz


#################################整体环境部署##############################

cd "/home/$name"
apt update
apt -y install build-essential pkg-config automake libtool git libgeoip-dev python3 python3-dev
apt -y install libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev
apt -y install qtbase5-dev qttools5-dev-tools libqt5svg5-dev zlib1g-dev

####################################编译boost##############################
cd $boost_dir
apt-get -y install mpi-default-dev　　#安装mpi库
apt-get -y install libicu-dev　　　　　#支持正则表达式的UNICODE字符集　
apt-get -y install libbz2-dev

wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2
tar -jxvf boost_1_75_0.tar.bz2
cd boost_1_75_0
sh ./bootstrap.sh
./b2
./b2/install

####################################编译libtorrent############################

cd $lib_dir
apt -y install libssl-dev
apt -y install openssl

wget https://github.com/arvidn/libtorrent/releases/download/v1.2.11/libtorrent-rasterbar-1.2.11.tar.gz
tar xf libtorrent-rasterbar-1.2.11.tar.gz
cd libtorrent-rasterbar-1.2.11
./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++14

make -j$(nproc)
make install
ldconfig

#########################安装qbittorrent########################
cd $qbit_dir
apt-get -y install qt5-default
apt-get -y install zlib1g-dev

# 将命令改名，可能是新版本的调用脚本命名不一样了
file1="/usr/bin/lrelease"
file2="/bin/lrelease"
if [ -f "$file1" ]; then
  mv "$file1" "${file1}-qt5"
fi
if [ -f "$file2" ]; then
  mv "$file2" "${file21}-qt5"
fi

wget https://github.com/qbittorrent/qBittorrent/archive/release-4.3.3.tar.gz
tar xf release-4.3.3.tar.gz
cd qBittorrent-release-4.3.3
./configure --disable-gui --disable-debug

make -j$(nproc)
make install

# 写入配置文件
qbit_service="/etc/systemd/system/qbittorrent.service"
touch $qbit_service
cat>$qbit_service<<EOF
[Unit]
Description=qBittorrent Daemon Service
After=network.target
[Service]
LimitNOFILE=512000
User=root
ExecStart=/usr/local/bin/qbittorrent-nox
ExecStop=/usr/bin/killall -w qbittorrent-nox
[Install]
WantedBy=multi-user.target
EOF

systemctl enable qbittorrent.service # 设置开机自启动
echo y|qbittorrent-nox --webui-port=2021
echo -e '\003'

################################设置qbittorrent命令###########################
qbit_command="/usr/bin/qbittorrent"
touch $qbit_command
cat>$qbit_command<<EOF
#!/bin/bash
if [ \$1 == "start" ]
then
  systemctl start qbittorrent.service #启动qBittorrent
elif [ \$1 == "stop" ]
then
  systemctl stop qbittorrent.service #关闭qBittorrent
elif [ \$1 == "restart" ]
then
  systemctl restart qbittorrent.service #重启qBittorrent
fi
EOF
cd /usr/bin && chmod +x qbittorrent
