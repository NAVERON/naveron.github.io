
# Docker 与 Podman

Docker 和 Podman 都是用于构建、分发和运行容器的工具。它们都遵循 OCI（Open Container Initiative）标准，常用命令和使用方式非常相似。

本文以 Podman 为主，Docker 仅作简要介绍。

## 1. Docker 简介

Docker 是较早普及的容器工具，采用客户端—守护进程（daemon）架构。用户通过 `docker` 命令与 Docker daemon 交互，由 daemon 负责管理镜像、容器、网络和存储。

常见命令示例：

```bash
docker pull nginx
docker run -d --name web -p 8080:80 nginx
docker ps
```

## 2. Podman 简介

Podman 是一个兼容 Docker 命令习惯的容器管理工具，支持 Linux、macOS 和 Windows。它不依赖常驻的中心化 daemon，命令执行时直接管理容器，因此结构更简单，也便于使用 rootless（非 root 用户）模式。

Podman 的主要特点：

- **Daemonless**：不需要长期运行的后台服务。
- **Rootless**：普通用户即可运行容器，降低权限风险。
- **兼容 OCI**：可以使用大多数 OCI 镜像和运行时。
- **兼容 Docker 命令**：很多 Docker 命令可以直接替换为 Podman 使用。
- **支持 Pod**：可以将多个相关容器组织到同一个 Pod 中。

> 以下示例默认已经安装 Podman。不同发行版的安装方式可能不同。

## 3. Docker 与 Podman 的主要区别

| 对比项 | Docker | Podman |
| --- | --- | --- |
| 架构 | 通常依赖 Docker daemon | 无需常驻 daemon |
| 默认使用方式 | 通常以 root 权限运行 daemon | 支持 rootless |
| 命令 | `docker` | `podman` |
| Pod 支持 | 需要额外方案或工具 | 原生支持 |
| 镜像格式 | OCI/Docker 镜像 | OCI/Docker 镜像 |

两者的核心概念基本一致：镜像用于创建容器，容器是镜像运行后的实例。

## 4. 镜像与容器

### 4.1 镜像（Image）

镜像是用于创建容器的只读模板，通常由多层文件系统组成。镜像可以包含：

- 应用程序及其依赖；
- 基础操作系统文件；
- 环境变量、工作目录和启动命令等元数据。

镜像通常存放在镜像仓库（Registry）中，例如 Docker Hub、Quay.io 或私有仓库。镜像名称一般由仓库、命名空间、名称和标签组成：

```text
quay.io/podman/hello:latest
```

如果没有明确指定标签，通常会使用 `latest`，但生产环境更建议使用明确的版本标签或摘要。

### 4.2 容器（Container）

容器是镜像的运行实例。容器拥有独立的进程、网络和文件系统视图，但共享宿主机内核。容器本身通常是临时的：删除容器后，容器内部未持久化的数据也会丢失。

需要长期保存的数据应通过 **数据卷（Volume）** 或 **绑定挂载（Bind Mount）** 保存到容器外部。

### 4.3 镜像、容器与仓库的关系

```text
镜像仓库  --pull-->  本地镜像  --run-->  容器
本地容器  --commit--> 新镜像
```

## 5. Podman 镜像操作

### 5.1 搜索镜像

```bash
podman search nginx
```

### 5.2 拉取镜像

```bash
podman pull docker.io/library/nginx:latest
```

### 5.3 查看本地镜像

```bash
podman images
```

### 5.4 删除镜像

```bash
podman rmi nginx:latest
```

镜像仍被容器使用时，可能无法直接删除，需要先删除相关容器，或确认是否要强制删除。

### 5.5 构建镜像

在包含 `Containerfile` 或 `Dockerfile` 的目录中执行：

```bash
podman build -t my-app:1.0 .
```

`-t` 用于为镜像设置名称和标签，`.` 表示使用当前目录作为构建上下文。

## 6. Podman 容器操作

### 6.1 创建并启动容器

```bash
podman run -d --name web nginx:latest
```

常用选项：

- `-d`：后台运行；
- `--name`：设置容器名称；
- `-p 宿主机端口:容器端口`：映射端口；
- `-v 宿主机路径:容器路径`：挂载目录或文件；
- `-e KEY=value`：设置环境变量；
- `--rm`：容器停止后自动删除。

### 6.2 查看容器

```bash
podman ps       # 查看运行中的容器
podman ps -a    # 查看全部容器
```

### 6.3 停止、启动和重启

```bash
podman stop web
podman start web
podman restart web
```

### 6.4 查看日志和进入容器

```bash
podman logs web
podman logs -f web
podman exec -it web /bin/sh
```

`exec` 会在正在运行的容器中执行命令。容器中是否存在 `/bin/sh` 取决于镜像内容，也可能需要使用 `/bin/bash`。

### 6.5 查看详细信息

```bash
podman inspect web
```

### 6.6 删除容器

```bash
podman rm web
podman rm -f web
```

删除运行中的容器需要使用 `-f`，但生产环境中应先确认容器内的数据是否已经持久化。

## 7. 使用端口和数据卷

### 7.1 端口映射

下面的命令将宿主机的 `8080` 端口映射到容器的 `80` 端口：

```bash
podman run -d --name web -p 8080:80 nginx:latest
```

之后可以通过 `http://localhost:8080` 访问服务。

### 7.2 绑定挂载

```bash
mkdir -p ./html
podman run -d --name web \
	-p 8080:80 \
	-v "$PWD/html:/usr/share/nginx/html:ro" \
	nginx:latest
```

其中 `ro` 表示容器以只读方式挂载该目录。绑定挂载适合使用宿主机上的配置文件、源代码或静态资源。

### 7.3 数据卷

```bash
podman volume create app-data
podman volume ls
podman volume inspect app-data
```

使用数据卷运行容器：

```bash
podman run -d --name app \
	-v app-data:/var/lib/app \
	my-app:1.0
```

## 8. Podman Pod

Pod 是一组共享网络命名空间的容器，适合组织一个应用及其辅助服务。创建 Pod 并映射端口：

```bash
podman pod create --name web-pod -p 8080:80
podman run -d --pod web-pod --name web nginx:latest
podman pod ps
```

Pod 的端口通常在创建 Pod 时统一配置。

## 9. 一个完整的创建容器示例

> 使用mysql和redis的镜像分别创建了容器，并测试成功

```bash
podman run -d \
  --name mysql-server \
  -e MYSQL_ROOT_PASSWORD=xxx \
  -e MYSQL_DATABASE=test \
  -e MYSQL_USER=test \
  -e MYSQL_PASSWORD=123 \
  -p 3306:3306 \
  -v mysql-data:/var/lib/mysql \
  docker.1ms.run/library/mysql:lts

podman run -d \
  --name redis-server \
  -p 6379:6379 \
  -v redis-data:/data \
  docker.1ms.run/library/redis:trixie \
  redis-server --appendonly yes --requirepass xxx
```

> 实际应用中，通常使用podman-compose或docker-compose来管理多个容器的创建和运行。

## 10. 常用命令速查

| 目的 | Podman 命令 |
| --- | --- |
| 拉取镜像 | `podman pull IMAGE` |
| 查看镜像 | `podman images` |
| 创建并运行容器 | `podman run ... IMAGE` |
| 查看运行中的容器 | `podman ps` |
| 查看全部容器 | `podman ps -a` |
| 查看日志 | `podman logs CONTAINER` |
| 进入容器 | `podman exec -it CONTAINER sh` |
| 停止容器 | `podman stop CONTAINER` |
| 删除容器 | `podman rm CONTAINER` |
| 删除镜像 | `podman rmi IMAGE` |
| 查看帮助 | `podman COMMAND --help` |
