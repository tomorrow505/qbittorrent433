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
echo -n "输入你的qb密码："
read pwd
lib_dir="/home/${name}/libtorrent"
qbit_dir="/home/${name}/qbittorrent"
boost_dir="/home/${name}/boost"
autoseed_dir="/home/${name}/Autoseed"

mkdir "/home/$name" &>>install.log
mkdir $lib_dir &>>install.log
mkdir $qbit_dir &>>install.log
mkdir $boost_dir &>>install.log
mkdir $autoseed_dir &>>install.log

cd $autoseed_dir && mkdir cache && chmod 777 cache &>>install.log
cd $autoseed_dir && mkdir tmp && chmod 777 tmp &>>install.log
cd $qbit_dir && mkdir torrent && mkdir download &>>install.log

#################################整体环境部署##############################

cd "/home/$name"

echo "正在更新……"
apt update &>>install.log

echo "正在配置整体编译环境……"
apt -y install build-essential pkg-config automake libtool git libgeoip-dev python3 python3-dev &>>install.log
apt -y install libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev &>>install.log
apt -y install qtbase5-dev qttools5-dev-tools libqt5svg5-dev zlib1g-dev &>>install.log

####################################编译boost##############################

cd $boost_dir
echo "开始编译boost，安装必要的包……"
apt-get -y install mpi-default-dev　&>>install.log　#安装mpi库
apt-get -y install libicu-dev &>>install.log　　　　 #支持正则表达式的UNICODE字符集　
apt-get -y install libbz2-dev &>>install.log

echo "开始获取文件并编译……"
wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2 &>>install.log
tar -jxvf boost_1_75_0.tar.bz2 > /dev/null
cd boost_1_75_0
sh ./bootstrap.sh &>>install.log
./b2 &>>install.log
./b2/install &>>install.log
echo "编译boost成功……"

####################################编译libtorrent############################

cd $lib_dir
echo "开始编译libtorrent，安装必要的包……"
apt -y install libssl-dev &>>install.log
apt -y install openssl &>>install.log

echo "开始获取文件并编译……"
wget https://github.com/arvidn/libtorrent/releases/download/v1.2.11/libtorrent-rasterbar-1.2.11.tar.gz &>>install.log
tar xf libtorrent-rasterbar-1.2.11.tar.gz &>>install.log
cd libtorrent-rasterbar-1.2.11
./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++14 &>>install.log

make -j$(nproc) &>>install.log
make install &>>install.log
ldconfig &>>install.log
echo "编译libtorrent成功……"

####################################安装qbittorrent#############################

cd $qbit_dir
echo "开始编译qbittorrent，安装必要的包……"
apt-get -y install qt5-default &>>install.log
apt-get -y install zlib1g-dev &>>install.log

# 将命令改名，可能是新版本的调用脚本命名不一样了
file1="/usr/bin/lrelease"
file2="/bin/lrelease"
if [ -f "$file1" ]; then
  mv "$file1" "${file1}-qt5"
fi
if [ -f "$file2" ]; then
  mv "$file2" "${file21}-qt5"
fi

echo "开始获取文件并编译……"
wget https://github.com/qbittorrent/qBittorrent/archive/release-4.3.3.tar.gz &>>install.log
tar xf release-4.3.3.tar.gz &>>install.log
cd qBittorrent-release-4.3.3
./configure --disable-gui --disable-debug  &>>install.log

make -j$(nproc) &>>install.log
make install &>>install.log
echo "qbittorrent编译成功！！！"

echo "第一次运行qbittorrent，请按ctrl+c结束……"
echo y|qbittorrent-nox --webui-port=2021 && pid=$! # 开启qb
kill -s 2 $pid
# echo $'\003' # 尝试ctrl+c退出

#################################写入配置文件###################################

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

# command=$(ls $HOME/.config/qBittorrent/)
# echo $command
echo "开始写入配置文件……"
qbit_conf1="$HOME/.config/qBittorrent/qBittorrent.conf"
qbit_conf2="$HOME/.config/qBittorrent/qbittorrent.conf"
if [ -f "$qbit_conf1" ]; then
  qbit_conf=$qbit_conf1
else
  qbit_conf=$qbit_conf2
fi
mv $qbit_conf "${qbit_conf}.old" && touch $qbit_conf

cat<<EOF>$qbit_conf
[AutoRun]
enabled=true
program=/bin/bash /usr/bin/up \"%I\"
[Application]
FileLogger\Enabled=true
FileLogger\Age=6
FileLogger\DeleteOld=true
FileLogger\Backup=true
FileLogger\AgeType=1
FileLogger\Path=/home/${name}/.config/qBittorrent
FileLogger\MaxSize=20
[BitTorrent]
Session\AnnounceToAllTiers=true
Session\AsyncIOThreadsCount=4
Session\CheckingMemUsageSize=16
Session\ChokingAlgorithm=FixedSlots
Session\CoalesceReadWrite=false
Session\FilePoolSize=40
Session\GuidedReadCache=true
Session\MultiConnectionsPerIp=false
Session\SeedChokingAlgorithm=FastestUpload
Session\SendBufferLowWatermark=10
Session\SendBufferWatermark=500
Session\SendBufferWatermarkFactor=50
Session\SocketBacklogSize=30
Session\SuggestMode=false
Session\uTPMixedMode=TCP
[LegalNotice]
Accepted=true
[Preferences]
Advanced\AnnounceToAllTrackers=false
Advanced\RecheckOnCompletion=false
Advanced\osCache=true
Advanced\trackerPort=9000
Bittorrent\AddTrackers=false
Bittorrent\DHT=false
Bittorrent\Encryption=1
Bittorrent\LSD=false
Bittorrent\MaxConnecs=-1
Bittorrent\MaxConnecsPerTorrent=-1
Bittorrent\MaxRatioAction=0
Bittorrent\PeX=false
Bittorrent\uTP=false
Bittorrent\uTP_rate_limited=true
Connection\GlobalDLLimitAlt=0
Connection\GlobalUPLimitAlt=0
Connection\ResolvePeerCountries=true
Connection\PortRangeMin=2000
Downloads\DiskWriteCacheSize=64
Downloads\DiskWriteCacheTTL=60
Downloads\SavePath=/home/$name/qbittorrent/download
Downloads\SaveResumeDataInterval=3
Downloads\ScanDirsV2=@Variant(\0\0\0\x1c\0\0\0\0)
Downloads\StartInPause=false
Downloads\TorrentExportDir=/home/$name/qbittorrent/torrent
General\Locale=zh
Queueing\QueueingEnabled=false
#Disable CSRF Protection For PT Plugin Plus
WebUI\AlternativeUIEnabled=false
WebUI\CSRFProtection=false
WebUI\HostHeaderValidation=true
WebUI\LocalHostAuth=false
WebUI\Port=2021
WebUI\RootFolder=/opt/qBittorrent/WebUI/miniers.qb-web
EOF
if [[ -z $(command -v qbpass) ]]; then
    wget --no-check-certificate -nv https://github.com/KozakaiAya/libqbpasswd/releases/download/v0.2/qb_password_gen_static -O /usr/local/bin/qbpass
    chmod +x /usr/local/bin/qbpass
fi
qbPassOld=$(echo -n $pwd | md5sum | cut -f1 -d ' ')
qbPassNew=$(/usr/local/bin/qbpass $pwd)
cat << EOF >> $qbit_conf
WebUI\Username=$name
WebUI\Password_ha1=@ByteArray($qbPassOld)
WebUI\Password_PBKDF2="@ByteArray($qbPassNew)"
EOF
echo "配置文件写入完成！！！"

################################设置qbittorrent命令###############################

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

echo "已经创建快捷键qbittorrent start|stop|restart用于开启|关闭|重启qbittorrent服务……"
echo "安装到此结束…………………………"

##############################配置剧鸡相关###############################

echo -n "是否想要安装其他剧鸡需要的python包(y|n)?"
read install_other
if [[ install_other == "y" ]] || [[ install_other == "Y" ]]; then
    apt -y install mediainfo
    apt -y install ffmpeg
    apt -y install lrzsz
    apt -y install python3-pip

    pip3 install setuptools 
    pip3 install bencode.py 
    pip3 install cn2an 
    pip3 install requests 
    pip3 install qbittorrent-api 
    pip3 install bs4 
    pip3 install lxml 
    pip3 install pymediainfo 
    pip3 install pyimgbox

    # 创建up命令用于剧鸡的使用，主文件问main.py
    up_path="/usr/bin/up"
    touch $up_path
    cat>$up_path<<EOF
    #!/bin/bash
    python3 "${autoseed_dir}/main.py" -i "\$1"
    EOF
    cd /usr/bin/ && chmod +x up
fi
