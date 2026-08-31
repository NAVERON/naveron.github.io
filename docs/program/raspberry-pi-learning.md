
# 树莓派系统的安装与设置

## 基本参考资料

1. 树莓派官方镜像写入工具：如果需要擦除 SD 卡并恢复为普通存储卡，需要使用这个工具，参考 [raspberry OS tools - rpi-imager](https://www.raspberrypi.com/software/)。
2. 树莓派专用的 `Ubuntu Server` 镜像及安装说明，参考 [ubuntu server for raspberry pi install guide](https://ubuntu.com/download/raspberry-pi)。
3. 使用 `rpi-imager` 写入 Ubuntu 镜像时，需要提前设置树莓派访问主机名 `host = raspberrypi.local`，并配置登录用户名和密码。
4. 树莓派通电后，可以通过 SSH 访问：`ssh xxx@raspberrypi.local`，随后输入密码。

> 直接用网线连接树莓派，并获取内网地址后，就可以直接通过 SSH 登录树莓派控制终端。

---

# 开发环境

使用 `sudo apt install xxx` 命令安装所需的软件环境：

- Java
- Go
- Lua
- Rust
- ...

## WiFi

- 安装网络管理工具：[network-manager](https://ubuntu.com/core/docs/networkmanager)
- 安装树莓派配置管理工具：[raspi-config] `sudo apt install raspi-config`

## 遗留问题

如果外部环境变化，例如 `WiFi` 无法连接，如何在不依赖无线网络的情况下，直接用网线连接笔记本并登录树莓派进行控制？

> 可以通过网线连接树莓派，并获取其 IP 地址，然后使用 SSH 进入树莓派命令行执行命令。`Ubuntu Server` 也有相应的网络配置方式，需要根据资料补齐完整的设置流程，并实现 WiFi 连接配置。

---

# 树莓派相关资料

> [https://rpi.thibmaek.com/](https://github.com/thibmaek/awesome-raspberry-pi)：关于树莓派系统、工具和项目资料的整理。
> [https://github.com/Botspot/pi-apps](https://github.com/Botspot/pi-apps)：树莓派应用商店；如果有开源的树莓派应用，也可以上架到商店，方便其他人使用。
> [https://github.com/raspberrypi/documentation](https://github.com/raspberrypi/documentation)：树莓派官方文档。
> [https://github.com/wwj718/awesome-raspberry-pi-zh](https://github.com/wwj718/awesome-raspberry-pi-zh)：中文资料整理。
> [https://github.com/jveverka/rpi-projects](https://github.com/jveverka/rpi-projects)：一些树莓派驱动和有趣项目实现。

## 一些有趣的树莓派项目

### pi temperature

> 树莓派 CPU / GPU 温度检测小程序。

GitHub： [https://github.com/s-nagaev/pi-temperature-exporter](https://github.com/s-nagaev/pi-temperature-exporter)  
Docker： `docker pull pysergio/pi-temp-exporter`

### java for pi io

> [pi for java](https://pi4j.com/about/)：Java 库，用于操作树莓派的 IO 硬件。

---

## 树莓派案例

[Raspberry Pi Hardware Programming with Python](http://radiostud.io/raspberrypi-hardware-interface-programming-python/)  
Raspbian Wheezy  
The RPi.GPIO module is installed by default in Raspbian. To make sure that it is at the latest version:

```shell
$ sudo apt-get update
$ sudo apt-get install python-rpi.gpio python3-rpi.gpio
```

To install the latest development version from the project source code library:

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

- [网页远程控制树莓派 LED 信号](https://www.pubnub.com/blog/2015-06-11-remote-control-raspberry-pi-leds-from-a-web-browser-ui/)
- [模拟信号案例](http://radiostud.io/sensing-analog-signal-raspberrypi/?utm_source=rpi-py-res-page&utm_medium=analoginput&utm_campaign=rpi-hwintf&doing_wp_cron=1525790331.7828059196472167968750)

---

# 一些硬件的保养

## 电量检测

显示器朝向自己，电池插头没有箭头的一侧朝向自己时，可以看到电量。  
购买 BB 响截图。

![电量检测](../../assert/images/tools/电量检测.png)

## 电池电压

![电池电压：避免长时间不用，应当每月进行一次放电和充电](../../assert/images/tools/电池使用.png)

## 充电器使用

![充电器](../../assert/images/tools/电池使用.png)


