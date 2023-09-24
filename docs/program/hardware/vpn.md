---
title: vpn clash
layout: post
parent: hardware
---

vpn  
{: .label .label-red}

# ssr dog

> [SSR DOG](https://dog.ssrdog111.com/#/account/dashboard)  

# clash

> https://github.com/Dreamacro/clash/releases  
> [clash docb](https://dreamacro.github.io/clash/configuration/configuration-reference.html)  

clash for linux 使用
- github下载 : https://github.com/Dreamacro/clash  
- 本地设置执行权限 `chmod +x xxx` 
- 第一次运行, 生成空的配置文件, 需要从订阅中心下载订阅配置, 替换默认配置  
- 再次运行, 检查是否有报错, 运行浏览器进入地址 [proxy config](http://clash.razord.top/#/proxies), 根据配置文件中的地址和secret进入配置  
- 上面的地址是可以配置本地的全局代理的, 也可以直接在系统的proxy中设置, 也可以在浏览器的网络带里设置中  
- edge 使用`SwitchyOmega`插件, firefox使用代理设置, 其中地址一般写为`127.0.0.1:xxxx` 端口号在clash配置文件中设置


