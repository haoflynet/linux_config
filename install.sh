#!/bin/bash

# author:haofly

# 设置非必要的组件
need_sftp=true

# 安装配置更新源
version=`head -n 1 /etc/issue | awk '{print $1}'`
version_number=`head -n 1 /etc/issue | awk '{print $2}' | awk -F '.' '{print $1$2}'`
sources_name=`ls | grep "$vaersion" | grep "$versoin_number"`
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp ./sources.list/$sources_name /etc/apt/sources.list

# 更新
apt-get update && apt-get upgrade -y

# VIM安装与配置
apt-get install vim -y

# SFTP安装与配置
if [ "$need_sftp" = true ] ; then
	apt-get install vsftpd
	sed 's/anonymous_enable=NO/anonymous_enable=YES/g' -i /etc/vsftpd.conf
	sed 's/#local_enable=YES/local_enable=YES/g' -i /etc/vsftpd.conf
	sed 's/#write_enable=YES/write_enable=YES/g' -i /etc/vsftpd.conf
	sed 's/#chroot_local_user/chroot_local_user/g' -i /etc/vsftpd.conf
	echo -n "输入SFTP目录(/home/ftp)："
	read ftp_path
	echo -n "输入SFTP用户名(ftpuser)："
	read ftp_user
	if [ "$ftp_path" == "" ] ; then
		$ftp_path="/home/ftp"
	fi
	if [ "$ftp_user" == "" ] ; then
		$ftp_user="ftpuser"
	fi
	useradd -d "$ftp_path" -s /usr/lib/sftp-server "$ftp_user"
	passwd "$ftp_user"
	mkdir "$ftp_path"
	chown "$ftp_user":"$ftp_user" "$ftp_path"
	service vsftpd restart
fi

