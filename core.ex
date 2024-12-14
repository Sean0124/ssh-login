#!/usr/bin/expect  

# 获取命令行参数  
set ip [lindex $argv 0]  
set port [lindex $argv 1]  
set username [lindex $argv 2]  
set password [lindex $argv 3]  
set use_sudo [lindex $argv 4]  ; # 新增参数，控制是否使用 sudo  

# 设置超时时间  
set timeout 20  

# 启动 SSH 连接  
spawn ssh -p $port $username@$ip  

# 处理密码提示  
expect {  
    "password:" { send "$password\r" }  
    "yes/no" { send "yes\r"; exp_continue }  
}  

# 如果需要使用 sudo，则执行 sudo -i  
if {$use_sudo == "true"} {  
    expect "$username" {  
        send "sudo -i\r"  
    }  
    expect {  
        "password for $username:" { send "$password\r" }  
        "yes/no" { send "yes\r"; exp_continue }  
    }  
}  

# 进入交互模式  
interact
