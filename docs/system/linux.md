---
title: linux related
layout: post
parent: system
---

linux  
{: .label}

tools  
{: .label .label-yellow}

markdown  
{: .label .label-green}

# linux basic

## linux command

- `uname -a` 内核操作系统cpu信息  
- `cat /proc/cpuinfo` cpu 信息  
- `free -m` 查看内存
- `df -h` 查看分区使用
- `ps -ef` 查看所有进程, `top`
- `ip addr` 查看网络接口属性, 类似于`ifconfig`
- `cat /proc/meminfo` 内存信息

# linux tools 

## asciinema

> 一个可以录制命令行执行命令的文本记录器, 一般演示命令输入和执行过程可以使用

- 官网 : [https://asciinema.org/ ](https://asciinema.org/)  
- 安装 : `sudo pip3 install asciinema` pip 或者 apt install asciinema 安装  

```shell
asciinema rec|play|cat|upload|auth file.cast  
# 其中rec录制 play重放 auth 绑定线上帐号 upload上床并声称一个线上链接  
```

## jq  

jq = json query, a shell command tools. url : [JQ](https://stedolan.github.io/jq/)  

## repo

repo = multi repo manager, from google. url : [Repo](https://source.android.com/setup/develop/repo)  


