#!/bin/bash

cat>input.data<<EOF
$1
03
04
T
09
\n
EOF

bluray < input.data > output.data

path=$(cat output.data | sed -n '/Files are stored/p' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d'"' -f2)

python3 /home/send_picture_from_dir.py -p $path
