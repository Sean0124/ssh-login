#!/bin/bash

# 获取是否使用 sudo 的参数
use_sudo="${1:-n}"  # 默认值为 'n'

dir="${HOME}/ssh-login-tool/"
file="${dir}computerInfo"
echo $file
#显示机器信息 过滤第一行和空行
#awk '{if (NR > 1 && $1 != ""){printf "%-2s %-45s %-15s \n",NR")",$5,$1}}' $file 
awk '{if ($1 !~ /^#/ && NR > 1 && $1 != ""){printf "%-2s %-45s %-15s \n",NR")",$5,$1}}' $file 
echo "please choose which machine to login:"
read number

# 验证输入是否为有效数字
if ! [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "无效输入，请输入一个数字。"
    exit 1
fi

#将信息存入变量
read ip port user password <<< $(echo `awk 'NR=="'$number'"{print $1,$2,$3,$4}' $file`)

# 调用 Expect 脚本
sudo="false"
if [ "$use_sudo" == "y" ]; then
    sudo="true"
fi
#expect "${dir}core.ex" "$ip" "$port" "$user" "$password" "$sudo"
expect "core.ex" "$ip" "$port" "$user" "$password" "$sudo"
