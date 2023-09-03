---
title: raspberry install
layout: post
parent: hardware
---

# 树莓派系统的安装和设置 

基本参考资料
1. 树莓派官方镜像写入工具, 如果需要擦除, 需要使用这个工具还原`tf卡`为普通存储卡 [raspberry OS tools - rpi-imager](https://www.raspberrypi.com/software/)  
2. 树莓派专用的`Ubuntu Server`镜像以及教程 [ubuntu server for raspberry pi install guide](https://ubuntu.com/download/raspberry-pi)  
3. 使用`rpi-image`写入ubuntu镜像时, 需要提前设置树莓派访问`host = raspberrypi.local`, 以及设置服务登录用户名和密码  
4. 树莓派通电并使用`ssh协议`访问:  `ssh xxx@raspberrypi.local` + 密码  

> 使用网现直接连接树莓派, 并获取内网地址, 可以直接ssh进入树莓派控制端  

# 开发环境 

使用`sudo apt install xxx`命令安装需要的软件环境  

- java  
- go  
- lua
- rust  
- ...

## 遗留问题  

如果外部环境变化, 如`wifi`网络无法连接， 如何直接使用网线连接笔记本直接登录控制 ?  

