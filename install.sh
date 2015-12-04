#/bin/bash

# author:haofly

# 安装配置更新源
version=`head -n 1 /etc/issue | awk '{print $1}'`
version_number=`head -n 1 /etc/issue | awk '{print $2}' | awk -F '.' '{print $1$2}'`


