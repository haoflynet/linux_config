#!/bin/bash

# author:haofly

# 设置非必要的组件
need_sftp=true
need_baiduyun=true

# 安装配置更新源
version=`head -n 1 /etc/issue | awk '{print $1}'`
version_number=`head -n 1 /etc/issue | awk '{print $2}' | awk -F '.' '{print $1$2}'`
sources_name=`ls | grep "$vaersion" | grep "$versoin_number"`
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./sources.list/$sources_name /etc/apt/sources.list

# 更新
apt-get update && apt-get upgrade -y

# 安装系统常用软件
apt-get install tree build-essential git curl -y

# VIM安装与配置
apt-get install vim -y
ln vim/vimrc ~/.vimrc
if [ ! -d ~/.vim ] ; then
	mkdir ~/.vim
fi
if [ ! -d ~/.vim/autoload ] ; then
	mkdir ~/.vim/autoload
fi
if [ ! -d ~/.vim/bundle ] ; then
	mkdir ~/.vim/bundle
fi
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
# 目录树插件
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/jistr/vim-nerdtree-tabs ~/.vim/bundle/vim-nerdtree-tabs


# Python3安装与配置
apt-get install python3 python3-dev python3-pip python-pip -y
pip install requests beautifulsoup4 


# bypy百度云安装与配置
if [ "$need_baiduyun" = true ] ; then
	echo "前往下列地址获取授权码，待会儿在Enter之前需要将其粘贴到终端"
	echo "http://openapi.baidu.com/oauth/2.0/authorize?scope=basic+netdisk&redirect_uri=oob&response_type=code&client_id=q8WE4EpCsau1oS0MplgMKNBn"
	echo ""
	if [ ! -d ~/download ]; then
		mkdir ~/download
	fi
	if [ ! -d ~/download/baiduyun ]; then
		git clone https://github.com/houtianze/bypy.git ~/download/baiduyun
	fi
	chmod +x ~/download/baiduyun/bypy.py 
	~/download/baiduyun/bypy.py info	# 初始设置
fi


# SFTP安装与配置
if [ "$need_sftp" = true ] ; then
	apt-get install vsftpd -y
	sed 's/anonymous_enable=NO/anonymous_enable=YES/g' -i /etc/vsftpd.conf
	sed 's/#local_enable=YES/local_enable=YES/g' -i /etc/vsftpd.conf
	sed 's/#write_enable=YES/write_enable=YES/g' -i /etc/vsftpd.conf
	sed 's/#chroot_local_user=NO/chroot_local_user=YES/g' -i /etc/vsftpd.conf
	
    read -p "输入SFTP目录(/home/ftp)：" ftp_path
    if [ ! -n "$ftp_path" ] ; then
            ftp_path="/home/ftp"
    fi
    if [ ! -d "$ftp_path" ] ; then
            mkdir "$ftp_path"
    fi
    read -p "输入SFTP账号(ftp_user)：" ftp_user
    if [ ! -n "$ftp_user" ] ; then
            ftp_user="ftpuser"
    fi
    useradd -d "$ftp_path" -s /usr/lib/sftp-server "$ftp_user"
    chown "$ftp_user":"$ftp_user" "$ftp_path"
    passwd "$ftp_user"
    service vsftpd restart
fi