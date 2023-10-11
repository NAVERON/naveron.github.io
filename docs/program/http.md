---
title: http related
layout: post
parent: program
---

http  
{: .label .label-gree }

httpie  
{: .label}

# httpie

> httpie一个命令行客户端工具 linux平台支持比较好 : [https://httpie.io/](https://httpie.io/)  

一般使用`pip install httpie`安装, 也有其他方式安装, 支持各个操作系统平台  

## usage

使用格式为`http/https [method] url params`, 一个典型的例子  

```shell
http PUT pie.dev/put \
    X-Date:today \                     # Header
    token==secret \                    # Query parameter
    name=John \                        # Data field
    age:=29                            # Raw JSON
```

## params

几个比较重要的参数  

- `--offline` 离线模式, 输出请求内容
- `--verbose` 打印详细信息
- `--form` post 表单形式
- `--follow` 跟随`302`跳转
- `--proxy` 代理
- `--verify=no` 不验证证书
- `--cert=client.pem --cert-key=client.key` 客户端ssl 认证
- `--ssl=ssl3` ssl协议版本, `ssl2, ssl3, tls1, tls1.1, tls1.2, tls1.3`  
- `--ciphers` 设置加密算法
- `--print` 控制打印内容; `--meta` 展示meta信息, 如请求耗时等; `--quiet` 不输出显示任何
- `--style` 设置风格颜色; `--pretty` 设置格式化样式. 如`http --offline --style=monokai  pie.dev/get`
- `--download` 下载模式, 如 `http --download https://github.com/httpie/cli/archive/master.tar.gz`
- `--stream` 让请求输出类似于`tail -f`命令， 向后传递输出流, 可以用在长连接请求上, 持续输出内容, 并做处理
- `--session` http请求无状态, httpie提供了session功能, 相当于后端的session功能; `--session-read-only` 只读session
- `--check-status` 检查status返回
```shell
#!/bin/bash

if http --check-status --ignore-stdin --timeout=2.5 HEAD pie.dev/get &> /dev/null; then
    echo 'OK!'
else
    case $? in
        2) echo 'Request timed out!' ;;
        3) echo 'Unexpected HTTP 3xx Redirection!' ;;
        4) echo 'HTTP 4xx Client Error!' ;;
        5) echo 'HTTP 5xx Server Error!' ;;
        6) echo 'Exceeded --max-redirects=<n> redirects!' ;;
        *) echo 'Other Error!' ;;
    esac
fi
```
- ...

# https&https



