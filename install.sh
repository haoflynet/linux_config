#!/bin/bash

# author:haofly

# 安装配置更新源
version=`head -n 1 /etc/issue | awk '{print $1}'`
version_number=`head -n 1 /etc/issue | awk '{print $2}' | awk -F '.' '{print $1$2}'`
sources_name=`ls | grep "$vaersion" | grep "$versoin_number"`
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./sources.list/$sources_name /etc/apt/sources.list

# 更新
sudo apt-get update && sudo apt-get upgrade -y

# VIM
sudo apt-get install vim -y

# tree
sudo apt-get install tree
