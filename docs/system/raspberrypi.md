---
title: raspberry pi
layout: post
parent: system
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

## 树莓派的案例  

[Raspberry Pi Hardware Programming with Python](http://radiostud.io/raspberrypi-hardware-interface-programming-python/)  
Raspbian Wheezy  
The RPi.GPIO module is installed by default in Raspbian. To make sure that it is at the latest version:  

```shell
$ sudo apt-get update
$ sudo apt-get install python-rpi.gpio python3-rpi.gpio
```

To install the latest development version from the project source code library :   

```shell
$ sudo apt-get install python-dev python3-dev
$ sudo apt-get install mercurial
$ sudo apt-get install python-pip python3-pip
$ sudo apt-get remove python-rpi.gpio python3-rpi.gpio
$ sudo pip install hg+http://hg.code.sf.net/p/raspberry-gpio-python/code#egg=RPi.GPIO
$ sudo pip-3.2 install hg+http://hg.code.sf.net/p/raspberry-gpio-python/code#egg=RPi.GPIO
```

To revert back to the default version in Raspbian:

```shell
$ sudo pip uninstall RPi.GPIO
$ sudo pip-3.2 uninstall RPi.GPIO
$ sudo apt-get install python-rpi.gpio python3-rpi.gpio
```

Other Distributions  
It is recommended that you install RPi.GPIO using the pip utility as superuser (root):  

```shell
# pip install RPi.GPIO
```

### 其他案例

[网页远程控制树莓派LED信号](https://www.pubnub.com/blog/2015-06-11-remote-control-raspberry-pi-leds-from-a-web-browser-ui/)  
[模拟信号案例](http://radiostud.io/sensing-analog-signal-raspberrypi/?utm_source=rpi-py-res-page&utm_medium=analoginput&utm_campaign=rpi-hwintf&doing_wp_cron=1525790331.7828059196472167968750)  

# 一些硬件的保养  

## 电量检测

显示器朝向自己，电池插头**没有箭头**的朝向自己，显示电量
购买BB响截图
![电量检测](../../assert/images/tools/电量检测.png)  

## 电池电压
![电池电压，避免长时间不用，应当每月放电充电](../../assert/images/tools/电池使用.png)  

## 充电器使用
![充电器](../../assert/images/tools/电池使用.png)  



