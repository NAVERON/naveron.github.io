# Distrobox 使用指南

> 说明：这份内容是 AI 生成的初稿，后续我根据自己的实际使用经验做了关键修正和补充，保留了真正有用的配置方式和踩坑记录。

## 1. Distrobox 是什么

**Distrobox**（Distribution Box）是一个在容器中运行其他 Linux 发行版的工具。它基于 `podman` 或 `docker`，把宿主机的用户环境、家目录、硬件、图形界面等都尽量无缝地带进容器里，让你在当前发行版上直接跑别的发行版软件。

- 我最常用的场景就是：在自己的系统上跑另一个发行版的工具链或软件包管理器，比如 `apt`、`dnf`。
- 容器内外的文件、应用、剪贴板、终端等信息大多是互通的，体验很接近“原生”。
- 对开发测试、隔离环境、特殊软件依赖来说，非常方便。

**官方网站**：<https://distrobox.it/>

### 安装

- **通用方式（推荐）**：在宿主机用脚本安装

  ```bash
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
  ```

- **通过包管理器**（部分发行版）：

  ```bash
  # Fedora
  sudo dnf install distrobox
  # Ubuntu / Debian
  sudo apt install distrobox
  # Arch
  sudo pacman -S distrobox
  ```

- 依赖：需要 `podman` 或 `docker` 之一（推荐 `podman`）。

### 简单使用

```bash
# 创建容器（指定发行版/版本和名称）
distrobox create --name ubuntu-2204 --image ubuntu:22.04

# 进入容器
distrobox enter ubuntu-2204

# 在容器中执行命令（不进交互 shell）
distrobox enter ubuntu-2204 -- lsb_release -a

# 列出所有容器
distrobox list

# 停止容器
distrobox stop ubuntu-2204

# 删除容器
distrobox rm ubuntu-2204

# 把宿主机应用导出到容器内使用
distrobox-export --app 应用名
```

## 2. 我的容器环境

当前系统已创建以下容器，用于一般开发：

| 容器名称 | 镜像 | 用途 |
| -------- | ---- | ---- |
| `ubuntu-2204` | `ubuntu:22.04` | 一般开发 |
| `ubuntu-2604` | `ubuntu:26.04` | 一般开发 |
| `debian-trixie` | `debian:trixie` | 一般开发 |
| `fedora-44` | `fedora:44` | 一般开发 |

## 3. 常见问题总结（持续补充）

### 3.1 `distrobox list` 中 `ubuntu-2604` 显示更多无关信息

**现象**：执行 `distrobox list` 后，`ubuntu-2604` 容器比其它容器多显示了很多无关信息（可能是额外的状态行、镜像信息、警告等）。

**原因**：这个问题和镜像本身有关，`ubuntu-2604` 在 `distrobox` 解析镜像名称和 ID 时，和之前的标签/解析逻辑没有完全对齐，最终表现为多出一堆无关信息。

**解决方法**：先等官方修复；如果需要继续用，直接换成更稳定的镜像，比如 `ubuntu:22.04`。

### 3.2 创建时初始化比较慢，使用 `pre-init` 命令解决

**现象**：创建容器时初始化过程很慢。

**原因**：初始化时默认会执行很多初始化脚本/软件包更新，拖慢整体时间。

**实际做法**：我用了 `--pre-init-hooks` 这个参数来做预处理：

```bash
distrobox create --name ubuntu-2204 --image ubuntu:22.04 \
  --pre-init-hooks "echo '跳过耗时的初始化步骤...'"
```

> 例如，创建 `debian-trixie` 容器时，使用了 `--pre-init-hooks` 来更新镜像源，避免初始化时的网络问题：

```bash
distrobox create \
  --image docker.1ms.run/library/debian:trixie \
  --name debian-trixie \
  --home ~/.distrobox-home/debian-trixie \
  --pre-init-hooks "sed -i 's|deb.debian.org|mirrors.cernet.edu.cn|g; s|security.debian.org|mirrors.cernet.edu.cn|g' /etc/apt/sources.list.d/debian.sources && apt-get update"
```

> 设置ubuntu时使用的替换命令：

```bash
sed -i 's|http://archive.ubuntu.com/ubuntu|http://mirrors.cernet.edu.cn/ubuntu|g; s|http://security.ubuntu.com/ubuntu|http://mirrors.cernet.edu.cn/ubuntu|g' /etc/apt/sources.list && apt update
```


## 4. 参考资料

- Distrobox 官网：<https://distrobox.it/>
- GitHub 仓库：<https://github.com/89luca89/distrobox>
