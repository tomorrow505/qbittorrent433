#!/bin/bash

# 读取输入的路径写入固定交互
cat>input.data<<EOF
$1
03
04
T
09
\n
EOF

# 使用固定交互命令执行bluray并输出到output.data
echo "正在截图……"
bluray < input.data > output.data

echo "读取截图路径……"
# 读取图片存储路径
path=$(cat output.data | sed -n '/Files are stored/p' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d'"' -f2)

echo "开始上传截图……"
# 调用python脚本搜索目录下的文件进行上传
python3 /home/up_bluray_picture.py -p $path
