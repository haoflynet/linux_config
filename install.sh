#!/bin/bash

# author:haofly

current_path=`pwd`

# 设置非必要的组件
<<<<<<< HEAD
need_sftp=true
need_baiduyun=true
need_ClamAV=true	# 杀毒软件
=======
need_sftp=true		# sftp
need_baiduyun=false # 百度云服务
need_mail=false 	# 邮件服务，以及登录自动发送邮件
>>>>>>> 98eb4564b99f1ccfcee978d22ff4593a0e9d4be0

# 安装配置更新源
version=`head -n 1 /etc/issue | awk '{print $1}'`
version_number=`head -n 1 /etc/issue | awk '{print $2}' | awk -F '.' '{print $1$2}'`
sources_name=`ls | grep "$vaersion" | grep "$versoin_number"`
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./sources.list/$sources_name /etc/apt/sources.list

# 更新
apt-get update && apt-get upgrade -y

# 安装系统常用软件
apt-get install tree build-essential cmake git curl unzip -y

# VIM安装与配置
apt-get install vim -y
ln ./vim/vimrc ~/.vimrc
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
git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic
# YouCompleteMe需要安装一些特殊的东西
git submodule update --init --recursive
# 如果需要更新vim
# sudo add-apt-repository ppa:fcwu-tw/ppa
# sudo apt-get update
# sudo apt-get install vim
# YouCompleteMe版本过低还要升级，官网下载https://cmake.org/download/
# cd ~/download/
# wget https://cmake.org/files/v3.4/cmake-3.4.1.tar.gz
# tar xf cmake-3.4.1.tar.gz
# cd cmake-3.4.1
# ./configure --enable-pythoninterp=yes   # 如果是python3那么就是--enable-python3interp=yes
# apt-get install chekinstall
# make && checkinstall
# cd current_path

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

# 邮件服务
if ["$need_mail" = true ] ; then
	apt-get install mailutils -y
	read -p "输入目标邮箱：" email
	if [ ! -n "$email" ] ; then
		email="admin@haofly.net"
	fi
	echo -E "
sendmail -t <<EOF
	to:""$email""
	from:""$email"'
	subject:$USER@`hostname` login from ${SSH_CLIENT%% *}
	$USER@`hostname` login from ${SSH_CLIENT%% *}
EOF' >> ~/.bashrc
fi