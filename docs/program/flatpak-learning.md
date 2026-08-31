# Flatpak 使用说明

> 说明：这份内容是 AI 生成的初稿，后续我根据自己的实际使用经验做了关键修正和补充，重点保留了能真正用起来的配置和注意事项。

## 1. Flatpak 是什么，以及如何配置和使用

Flatpak 是一种 Linux 应用分发与运行方式，类似 AppImage、Snap 这样的通用应用容器。对我来说，它最实用的地方就是：

- 应用和依赖相互隔离，减少系统冲突
- 不依赖发行版自带的软件包版本
- 可以在多个 Linux 发行版上统一安装应用
- 适合安装跨平台、较新的桌面软件

常见命令：

```bash
# 安装 Flatpak（以 Debian/Ubuntu 为例）
sudo apt install flatpak

# 若使用 GNOME 桌面，也建议安装插件
sudo apt install gnome-software-plugin-flatpak

# 查看已配置的源
flatpak remotes -v

# 添加官方 Flathub 源
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 或者使用系统级配置（如果你是管理员）
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

# 查看已经安装的应用
flatpak list

# 搜索应用
flatpak search firefox

# 安装应用
flatpak install flathub org.mozilla.firefox

# 运行应用
flatpak run org.mozilla.firefox

# 卸载应用
flatpak uninstall org.mozilla.firefox
```

注意：

- 一般建议使用 `--user` 模式，适合普通用户，避免影响系统
- 如果需要系统级共享安装，则使用 `--system`
- `flatpak install` 默认会在当前用户环境中安装

---

## 2. 设置国内镜像源与社区源（Flathub + Flatpark）

为了提高下载速度，我通常会先把 Flathub 指向国内镜像源；另外如果需要补充应用源，也会顺手加一个类似 `Flatpark` 这样的社区应用中心。它不是官方 `flathub`，但在功能上更像是社区版的 Flatpak 应用源，适合补充和扩展应用选择。

### 2.1 设置 Flathub 国内镜像

以常见镜像站为例：

```bash
# 先删除原来的官方源（若存在）
flatpak remote-delete flathub

# 添加国内镜像源（示例：CERNET/镜像站提供的地址）
flatpak remote-add --if-not-exists flathub https://mirrors.cernet.edu.cn/flathub/flathub.flatpakrepo
```

如果你使用的是其他镜像站，也可以按对应站点的地址替换：

```bash
flatpak remote-modify --url https://mirrors.cernet.edu.cn/flathub/flathub.flatpakrepo flathub
```

如果你的系统已存在 `flathub`，优先推荐使用 `remote-modify` 来修改 URL，而不是反复删加。

### 2.2 增加 Flatpark 这类社区源

你提到的“社区版 Flathub”，更准确地说是一个类似应用中心的 Flatpak 源，叫做 `Flatpark`，官网是 <https://flatpark.org/>。这种源本质上就是一个社区应用仓库/应用中心，适合补充和扩展应用选择。

```bash
# 添加 Flatpark 源（类似 Flathub 的社区应用中心）
flatpak remote-add --if-not-exists flatpark https://flatpark.org/repo/flatpark.flatpakrepo
```

这里的关键点是：

- `flathub`：官方主仓库，最稳定、最通用
- `flatpark`：类似社区版/扩展版应用中心，功能和用途与 Flathub 接近，但属于独立源
- 如果官网或镜像站提供的实际地址不同，请以官方文档中的真实 URL 为准

一般来说，先把 `flathub` 指到国内镜像就够用了；如果想再补充一些社区应用，`flatpark` 就可以作为一个额外源来启用。

### 2.3 查看当前远程配置

```bash
flatpak remotes -v
```

你会看到类似：

```text
flathub  https://mirrors.cernet.edu.cn/flathub/flathub.flatpakrepo  system
```

如果希望统一查看更详细信息：

```bash
flatpak remote-list --verbose
```

---

## 3. 设置多个源的优先级

Flatpak 可以配置多个远程源。为了让某个源优先被使用，可以调整优先级。

### 3.1 查看源优先级

```bash
flatpak remotes -v
```

### 3.2 设置优先级

```bash
# 将 flathub 提升到更高优先级
flatpak remote-modify --prio=1 flathub

# 如果想让 Flatpark 作为社区源优先
flatpak remote-modify --prio=2 flatpark
```

说明：

- `--prio` 的值越大，优先级越高
- 适用于多个源中有相同应用时，决定从哪个源拉取

如果你有多个国内镜像源，建议：

- 把最稳定、最完整的源设置为最高优先级
- 例如：`flathub` 最高，`flatpark` 次之

### 3.3 删除不需要的源

```bash
flatpak remote-delete flatpark
```

---

## 4. 安装普通应用的命令

### 4.1 搜索应用

```bash
flatpak search vscode
flatpak search telegram
flatpak search motrix
```

### 4.2 安装应用

```bash
# 安装常规应用示例
flatpak install flathub org.mozilla.firefox
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.github.Alacritty.Alacritty
```

### 4.3 运行应用

```bash
flatpak run org.mozilla.firefox
flatpak run com.github.Alacritty.Alacritty
```

### 4.4 更新应用

```bash
flatpak update
```

---

## 5. 特别强调：Motrix Next 只能在 Flatpak 源中找到

Motrix Next 这类应用，通常并不是系统软件包里直接提供的，很多时候只能通过 Flatpak 源搜索和安装。

### 5.1 先搜索

```bash
flatpak search motrix
```

如果搜索结果中有 Motrix 相关应用，则说明它在 Flathub 中可用。

### 5.2 安装命令示例

```bash
# 以 Motrix 为例，具体应用 ID 可能以搜索结果为准
flatpak install flathub com.github.motrixapp.Motrix
```

注意：

- 这里的应用 ID 是按实际搜索结果和 Flatpak 仓库里的名称而定
- 如果搜索结果里不是这个 ID，先不要手动猜测，直接用 `flatpak search motrix` 确认后再安装
- Motrix Next 多数情况下只能在 `flathub` 这类 Flatpak 源里找到，不会出现在 Debian/Ubuntu 官方仓库里

### 5.3 运行 Motrix

```bash
flatpak run com.github.motrixapp.Motrix
```

如果实际运行 ID 不是这个值，则以 `flatpak search motrix` 输出的结果为准。

---

## 6. 常用 Flatpak 速查

```bash
# 查看所有已安装应用
flatpak list

# 查看所有远程源
flatpak remotes

# 更新所有应用
flatpak update

# 列出所有可更新内容
flatpak update --appstream

# 查看详细信息
flatpak info <app-id>

# 卸载应用
flatpak uninstall <app-id>
```

---

## 7. 建议的实际配置方式

如果你是普通用户，推荐这样配置：

```bash
flatpak remote-add --if-not-exists flathub https://mirrors.cernet.edu.cn/flathub/flathub.flatpakrepo
flatpak remote-modify --prio=1 flathub
flatpak search motrix
flatpak install flathub com.github.motrixapp.Motrix
```

如果你还想补充社区应用源，例如 Flatpark：

```bash
flatpak remote-add --if-not-exists flatpark https://flatpark.org/repo/flatpark.flatpakrepo
flatpak remote-modify --prio=2 flatpark
```

这样可以同时兼顾：

- 国内镜像加速
- 稳定主源优先
- 额外社区源补充
- 便于扩展类似 Flatpark 这类应用中心的内容

---

## 8. 结论

Flatpak 是 Linux 上非常实用的应用安装方式。最关键的几点是：

1. 先安装 Flatpak，并添加 Flathub
2. 把 Flathub 指向国内镜像，减少下载慢的问题
3. 按需要增加社区镜像源
4. 设置多个源优先级，确保主源优先
5. 通过 `flatpak search` 和 `flatpak install` 安装应用
6. 与 Flathub 同类的社区源（如 Flatpark）可以作为补充源使用，提供更多应用中心与扩展选择

如果你按上述流程配置好，日常安装软件会比直接使用发行版仓库更灵活，也更适合一些新软件和跨发行版应用。
