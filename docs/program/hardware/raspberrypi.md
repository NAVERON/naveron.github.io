---
title: raspberry pi
layout: post
parent: hardware
---

raspberry pi  
{: .label}

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

## wifi 

安装网络管理 [network-manager](https://ubuntu.com/core/docs/networkmanager)  
安装树莓派配置管理 [raspi-config] `sudo apt install raspi-config`  


## 遗留问题  

如果外部环境变化, 如`wifi`网络无法连接， 如何直接使用网线连接笔记本直接登录控制 ?  

> 使用网线链接树莓派, 可以直接获取到ip地址, ssh进入树莓派命令行执行命令, `ubuntu server`有网络设置, 查阅资料实现完整的设置和连接wifi  

# 树莓派一些资料 

> [https://rpi.thibmaek.com/](https://github.com/thibmaek/awesome-raspberry-pi) : 关于树莓派的系统, 工具, 项目资料  
> [https://github.com/Botspot/pi-apps](https://github.com/Botspot/pi-apps) : 树莓派应用商店, 如果子级有开原的树莓派app, 可以上架商店方便其他人使用  
> [https://github.com/raspberrypi/documentation](https://github.com/raspberrypi/documentation) : 树莓派官方文档  
> [https://github.com/wwj718/awesome-raspberry-pi-zh](https://github.com/wwj718/awesome-raspberry-pi-zh) : 中文资料 
> [https://github.com/jveverka/rpi-projects](https://github.com/jveverka/rpi-projects) : 对pi提供的一些驱动和有趣的项目实现  

## 一些有趣的树莓派项目

### pi temperature

> 树莓派查看cpu gpu温度的检测小程序

github : [https://github.com/s-nagaev/pi-temperature-exporter](https://github.com/s-nagaev/pi-temperature-exporter)  
docker : `docker pull pysergio/pi-temp-exporter`  

### java for pi io

> [pi for java](https://pi4j.com/about/) : Java包 为操作树莓派的io硬件  




