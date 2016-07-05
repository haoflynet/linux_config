#!/bin/bash

# author:haofly
# 服务器配置，就是不用docker

## 更新
yum update && yum upgrade -y

## 安装常用软件
yum install vim tree git curl unzip epel-release gcc-c++ make -y

## Python3的安装与配置
yum install python34 python34-setuptools python34-devel python-pip -y
easy_install-3.4 pip

## nodejs安装
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum install nodejs -y
npm install -g hexo-cli


## blog
pip3 install requests beautifulsoup4 flask tornado django
yum install nginx -y

## 管理平台
yum install mariadb-server mariadb mariadb-devel -y
yum install mariadb-devel
pip3 install -r requirements.txt

## 安装docker
yum install docker-engine
service docker start

## 安装splash
docker pull scrapinghub/splash
