#!/usr/bin/env bash

# =============================================================================

#  面向 Debian/Ubuntu/Fedora 及其衍生版的「系统环境重建」辅助脚本
#
#  假设：当前用户为拥有 sudo 授权的管理员；系统级安装统一走 sudo，不处理 root。
#
#  当前功能
#    1) 跨发行版系统检测，导出统一环境变量（供本脚本及外部使用）
#    2) 便捷命令：base / flatpak-env / flatpak-apps / all / info / help
#    3) Flatpak 相关配置高度可定制：
#       - 源由 add_flatpak_remote 按「名称」单个配置，具体值由上层提供；
#       - 应用安装时由调用方指定 remote（flathub / flatpark / 其它）；
#       - 命令用的清单集中在文件头配置区。
#    4) 可复用函数（source 引入后可用），详见 help。
#
#  命名约定（bash 通用习惯）
#    - 全局导出变量   ：UPPER_SNAKE
#    - 局部变量       ：lower_snake
#    - 公开函数       ：全小写下划线，动词开头，<动词>_<对象>，如 add_flatpak_remote
#    - 私有辅助函数   ：以下划线开头，不对外使用
#
#  支持的系统
#    - Debian、Ubuntu 及衍生版（软件包管理器：apt）
#    - Fedora 及衍生版（软件包管理器：dnf）
#    - WSL（Windows Subsystem for Linux）可被识别
#
#  用法
#    bash eron-system-rebuild-2026.sh [命令 ...]   # 按命令执行（见 help）
#    source eron-system-rebuild-2026.sh            # 作为函数库引入，自行调用
#
#  detect_os 导出的环境变量
#    OS_NAME OS_ID OS_VERSION OS_CODENAME    发行版信息（来自 /etc/os-release）
#    KERNEL_NAME KERNEL_VERSION ARCH         内核与架构
#    PLATFORM IS_WSL PACKAGE_MANAGER         平台 / 是否 WSL / apt|dnf|unknown
#    OS_SUPPORTED                             1=支持 0=不支持
# =============================================================================

# -----------------------------------------------------------------------------
# 公共变量默认值（detect_os 运行前即保持可用；运行后被覆盖并 export）
# -----------------------------------------------------------------------------
OS_NAME="Unknown"
OS_ID=""
OS_VERSION=""
OS_CODENAME=""
KERNEL_NAME="Unknown"
KERNEL_VERSION="Unknown"
ARCH="Unknown"
PLATFORM=""
IS_WSL=0
PACKAGE_MANAGER="unknown"   # "apt" | "dnf" | "unknown"
OS_SUPPORTED=0              # 1 表示支持，0 表示不支持

# =============================================================================
# 可配置数据区（按需修改：命令与批量函数都会读取这里的值）
# =============================================================================

# 命令 base：通过系统包管理器安装的系统软件包。
# 提示：包名可与命令名不一致（如 python3-pip 对应命令 pip3/pip）。
SYSTEM_PACKAGES=(git maven python3 python3-pip)

# 命令 flatpak-env：需要添加的 Flatpak 源清单，每项四列，用 | 分隔：
#   <remote名称>|<flatpakrepo 地址>|<优先级(可空)>|<镜像URL(可空，用于替换下载地址)>
# 优先级数字越小优先级越高；留空表示不设置。
FLATPAK_REMOTES=(
    "flathub|https://dl.flathub.org/repo/flathub.flatpakrepo|10|https://mirrors.cernet.edu.cn/flathub"
    "flatpark|https://dl.flatpark.org/flatpark.flatpakrepo|5|"
)

# 命令 flatpak-apps：需要安装的 Flatpak 应用清单，每项两列，用 | 分隔：
#   <remote名称>|<应用ID>
# remote 名称须与 FLATPAK_REMOTES 中已配置的一致。
FLATPAK_APPS=(
    "flathub|cn.wps.wps_365"
    "flathub|com.cloudchewie.cloudotp"
    "flathub|io.github.ungoogled_software.ungoogled_chromium"
    "flathub|org.kde.kdenlive"
    "flathub|org.localsend.localsend_app"
)

# -----------------------------------------------------------------------------
# 私有辅助函数（供本脚本内部复用，不对外暴露）
# -----------------------------------------------------------------------------

# 刷新系统软件源索引（apt 需要；dnf 自动同步元数据，直接成功返回）
# 返回：始终为 0（刷新失败不阻断后续安装）
_update_manager_index() {
    [ "$PACKAGE_MANAGER" = "apt" ] || return 0
    sudo apt-get update >/dev/null 2>&1 || true
}

# 通过系统包管理器安装单个软件包（统一经 sudo 执行）
#  - 自动适配 apt / dnf
#  - apt 在安装前默认刷新索引；批量场景可设置 PM_SKIP_APT_UPDATE=1 只刷一次
# 返回：安装命令自身的退出码；包管理器未知时返回 3
_install_with_manager() {
    local pkg_name="$1"
    local -a cmd=()

    case "$PACKAGE_MANAGER" in
        apt)
            [ "${PM_SKIP_APT_UPDATE:-0}" = "1" ] || _update_manager_index
            cmd=(sudo apt-get install -y --no-install-recommends)
            ;;
        dnf)
            cmd=(sudo dnf -y install)
            ;;
        *)
            echo "未知的包管理器：$PACKAGE_MANAGER" >&2
            return 3
            ;;
    esac

    "${cmd[@]}" "$pkg_name"
}

# -----------------------------------------------------------------------------
# 第一部分：系统环境检测
# -----------------------------------------------------------------------------

# 检测系统环境，设置并导出头部声明的全部公共变量。
# 以「是否存在 apt/dnf」为支持依据，天然覆盖各发行版衍生系统。
# 返回：恒为 0
detect_os() {
    # ---- 1. 重置变量，保证函数可重复调用且结果干净 ----
    OS_NAME="Unknown"
    OS_ID=""
    OS_VERSION=""
    OS_CODENAME=""
    KERNEL_NAME="Unknown"
    KERNEL_VERSION="Unknown"
    ARCH="Unknown"
    PLATFORM=""
    IS_WSL=0
    PACKAGE_MANAGER="unknown"
    OS_SUPPORTED=0

    # ---- 2. 内核与架构信息 ----
    KERNEL_NAME=$(uname -s 2>/dev/null || echo "Linux")
    KERNEL_VERSION=$(uname -r 2>/dev/null || echo "Unknown")
    ARCH=$(uname -m 2>/dev/null || echo "Unknown")
    PLATFORM="${KERNEL_NAME}-${ARCH}"

    # ---- 3. 发行版信息 ----
    # 优先读取 /etc/os-release（Linux 发行版标准），缺失时退回 lsb_release
    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        OS_NAME=${PRETTY_NAME:-$NAME}
        OS_ID=${ID:-linux}
        OS_VERSION=${VERSION_ID:-${VERSION:-$KERNEL_VERSION}}
        OS_CODENAME=${VERSION_CODENAME:-}
    elif command -v lsb_release >/dev/null 2>&1; then
        OS_NAME=$(lsb_release -sd 2>/dev/null || echo "Linux")
        OS_VERSION=$(lsb_release -sr 2>/dev/null || echo "$KERNEL_VERSION")
        OS_ID=$(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "linux")
    else
        OS_NAME="Linux"
        OS_ID="linux"
        OS_VERSION="$KERNEL_VERSION"
    fi

    # ---- 4. WSL 识别 ----
    # 通过内核信息中是否含 "microsoft" 判断，WSL1 / WSL2 均适用
    if grep -qi microsoft /proc/version 2>/dev/null ||
       grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
        IS_WSL=1
    fi

    # ---- 5. 软件包管理器识别，并据此判定系统是否受支持 ----
    if command -v apt >/dev/null 2>&1 || command -v apt-get >/dev/null 2>&1; then
        PACKAGE_MANAGER="apt"
        OS_SUPPORTED=1
    elif command -v dnf >/dev/null 2>&1; then
        PACKAGE_MANAGER="dnf"
        OS_SUPPORTED=1
    fi
    # 其余情况保持默认值：PACKAGE_MANAGER="unknown"、OS_SUPPORTED=0

    export OS_NAME OS_ID OS_VERSION OS_CODENAME KERNEL_NAME KERNEL_VERSION ARCH PLATFORM IS_WSL PACKAGE_MANAGER OS_SUPPORTED

    return 0
}

# 以简洁易读的形式打印当前检测到的系统信息
# 返回：恒为 0
print_os_info() {
    cat <<EOF
    OS_NAME=$OS_NAME
    OS_ID=$OS_ID
    OS_VERSION=$OS_VERSION
    OS_CODENAME=$OS_CODENAME
    KERNEL_NAME=$KERNEL_NAME
    KERNEL_VERSION=$KERNEL_VERSION
    ARCH=$ARCH
    PLATFORM=$PLATFORM
    IS_WSL=$IS_WSL
    PACKAGE_MANAGER=$PACKAGE_MANAGER
    OS_SUPPORTED=$OS_SUPPORTED
EOF
}

# -----------------------------------------------------------------------------
# 第二部分：系统软件包安装
# -----------------------------------------------------------------------------

# 检测系统命令是否可用；若不可用则通过系统包管理器安装（幂等）。
# 用法：install_package <命令名或包名>
# 返回：0=已就绪  1=未指定包名  2=系统不支持自动安装  4=安装后仍未就绪
install_package() {
    local pkg_name="$1"

    if [ -z "$pkg_name" ]; then
        echo "用法: install_package <命令名或包名>" >&2
        return 1
    fi

    if command -v "$pkg_name" >/dev/null 2>&1; then
        echo "程序 '$pkg_name' 已安装。"
        return 0
    fi

    echo "程序 '$pkg_name' 未安装，正在尝试安装..."

    if [ "$OS_SUPPORTED" -ne 1 ]; then
        echo "无法自动安装：仅支持 apt/apt-get（Ubuntu/Debian/衍生）或 dnf（Fedora/衍生）系统。" >&2
        return 2
    fi

    _install_with_manager "$pkg_name"
    local rc=$?

    # 判定标准：命令已可用，或包管理器已报告安装成功
    # （后者用于兼容「包名 != 命令名」的情形，如 python3-pip）
    if command -v "$pkg_name" >/dev/null 2>&1 || [ "$rc" -eq 0 ]; then
        echo "程序 '$pkg_name' 安装成功。"
        return 0
    else
        echo "程序 '$pkg_name' 安装失败。" >&2
        return 4
    fi
}

# -----------------------------------------------------------------------------
# 第三部分：Flatpak 运行时 / 源 / 应用
# -----------------------------------------------------------------------------

# 检测系统是否具备 Flatpak 运行时；缺失时经系统包管理器安装（幂等）。
# 返回：0=已就绪  2=系统不支持自动安装  4=安装后仍未检测到 flatpak 命令
install_flatpak_runtime() {
    if command -v flatpak >/dev/null 2>&1; then
        echo "Flatpak 已安装。"
        return 0
    fi

    echo "Flatpak 未安装，正在尝试安装..."

    if [ "$OS_SUPPORTED" -ne 1 ]; then
        echo "无法自动安装 Flatpak：仅支持 apt/apt-get（Ubuntu/Debian/衍生）或 dnf（Fedora/衍生）系统。" >&2
        return 2
    fi

    _install_with_manager flatpak

    if command -v flatpak >/dev/null 2>&1; then
        echo "Flatpak 安装成功。"
        return 0
    else
        echo "Flatpak 安装失败。" >&2
        return 4
    fi
}

# 添加（幂等）单个 Flatpak 源，值全部由调用方提供。
# 用法：add_flatpak_remote <remote名称> <flatpakrepo地址> [优先级] [镜像URL]
# 说明：镜像 URL 用于把 remote 的实际下载地址切换为镜像（留空则用 flatpakrepo
#       自带的地址）；优先级数字越小优先级越高（留空则不设置）。
# 返回：0=已就绪  1=参数不完整  2=Flatpak 环境缺失
add_flatpak_remote() {
    local name="$1"
    local repo_url="$2"
    local priority="${3:-}"
    local mirror_url="${4:-}"

    if [ -z "$name" ] || [ -z "$repo_url" ]; then
        echo "用法: add_flatpak_remote <remote名称> <flatpakrepo地址> [优先级] [镜像URL]" >&2
        return 1
    fi

    if ! command -v flatpak >/dev/null 2>&1; then
        echo "Flatpak 未安装，请先执行 install_flatpak_runtime。" >&2
        return 2
    fi

    if flatpak remote-list | grep -qw "$name"; then
        echo "Flatpak 源 '$name' 已存在。"
    else
        echo "添加 Flatpak 源 '$name' ..."
        flatpak remote-add --if-not-exists "$name" "$repo_url"
    fi

    if [ -n "$mirror_url" ]; then
        flatpak remote-modify "$name" --url="$mirror_url"
    fi
    if [ -n "$priority" ]; then
        flatpak remote-modify "$name" --prio="$priority"
    fi

    echo "Flatpak 源 '$name' 配置完成。"
    return 0
}

# 按 FLATPAK_REMOTES 清单批量添加/配置全部源。
# 返回：0=全部成功  1=存在失败项
apply_flatpak_remotes() {
    if [ "${#FLATPAK_REMOTES[@]}" -eq 0 ]; then
        echo "FLATPAK_REMOTES 为空，跳过源配置。"
        return 0
    fi

    local entry name repo_url priority mirror_url failed=0
    for entry in "${FLATPAK_REMOTES[@]}"; do
        IFS='|' read -r name repo_url priority mirror_url <<< "$entry"
        if [ -z "$name" ] || [ -z "$repo_url" ]; then
            echo "忽略格式错误的源条目: '$entry'" >&2
            failed=1
            continue
        fi
        add_flatpak_remote "$name" "$repo_url" "$priority" "$mirror_url" || failed=1
    done
    return $failed
}

# 检测并安装单个 Flatpak 应用；安装源（remote）由调用方指定（幂等）。
# 用法：install_flatpak_app <remote名称> <应用ID>
# 前置条件：该 remote 已通过 add_flatpak_remote / apply_flatpak_remotes 配置。
# 返回：0=已安装/安装成功  1=参数不完整  2=Flatpak 环境缺失  3=安装失败
install_flatpak_app() {
    local remote="$1"
    local app_id="$2"

    if [ -z "$remote" ] || [ -z "$app_id" ]; then
        echo "用法: install_flatpak_app <remote名称> <应用ID>" >&2
        return 1
    fi

    if ! command -v flatpak >/dev/null 2>&1; then
        echo "Flatpak 未安装，请先执行 install_flatpak_runtime。" >&2
        return 2
    fi

    if flatpak list --app --columns=application | grep -qx "$app_id"; then
        echo "Flatpak 应用 '$app_id' 已安装。"
        return 0
    fi

    echo "正在从源 '$remote' 安装 Flatpak 应用 '$app_id' ..."
    flatpak install -y "$remote" "$app_id"

    if flatpak list --app --columns=application | grep -qx "$app_id"; then
        echo "Flatpak 应用 '$app_id' 安装成功。"
        return 0
    else
        echo "Flatpak 应用 '$app_id' 安装失败。" >&2
        return 3
    fi
}

# 按 FLATPAK_APPS 清单（<remote>|<应用ID>）批量安装应用。
# 前置条件：相关 remote 已配置。
# 返回：0=全部成功  1=存在失败项
install_flatpak_apps() {
    local entry remote app_id failed=0
    for entry in "${FLATPAK_APPS[@]}"; do
        IFS='|' read -r remote app_id <<< "$entry"
        if [ -z "$remote" ] || [ -z "$app_id" ]; then
            echo "忽略格式错误的应用条目: '$entry'" >&2
            failed=1
            continue
        fi
        install_flatpak_app "$remote" "$app_id" || failed=1
    done
    return $failed
}

# -----------------------------------------------------------------------------
# 第四部分：文件查找工具
# -----------------------------------------------------------------------------

# 在指定目录的「一级」子层中查找文件名包含全部给定关键字、且后缀匹配的文件。
# 用法：find_files_by_keywords <目录> <后缀> <关键字1> [关键字2] ...
# 示例：find_files_by_keywords ~/Download iso "ubuntu" "server"
# 返回：0=正常执行  1=参数不完整（结果逐行打印到 stdout）
find_files_by_keywords() {
    local search_dir="$1"
    shift
    local suffix="$1"
    shift
    local -a keywords=("$@")

    if [ -z "$search_dir" ] || [ -z "$suffix" ] || [ "${#keywords[@]}" -eq 0 ]; then
        echo "用法: find_files_by_keywords <目录> <后缀> <关键字1> [关键字2] ..." >&2
        return 1
    fi

    # 用进程替换逐行读取 find 结果，避免管道子 shell 导致的变量作用域问题
    local file keyword match
    while IFS= read -r file; do
        match=1
        for keyword in "${keywords[@]}"; do
            if [[ "$(basename "$file")" != *"$keyword"* ]]; then
                match=0
                break
            fi
        done
        if [ "$match" -eq 1 ]; then
            echo "$file"
        fi
    done < <(find "$search_dir" -maxdepth 1 -type f -name "*.$suffix")
}

# -----------------------------------------------------------------------------
# 第五部分：便捷命令（各自可独立执行；source 引入后也可直接调用）
# -----------------------------------------------------------------------------

# 命令 base：安装 SYSTEM_PACKAGES 中列出的系统软件包
# 返回：0=全部成功  1=存在失败项
install_system_packages() {
    local pkg_name failed=0

    # 批量安装场景下只需刷新一次软件源（_install_with_manager 据此跳过重复 update）
    local PM_SKIP_APT_UPDATE=1
    _update_manager_index

    for pkg_name in "${SYSTEM_PACKAGES[@]}"; do
        install_package "$pkg_name" || failed=1
    done
    return $failed
}

# 命令 flatpak-env：安装 Flatpak 运行时，并按 FLATPAK_REMOTES 清单配置源
# 返回：存在任一失败时返回非 0
setup_flatpak_env() {
    local failed=0

    install_flatpak_runtime || failed=1
    apply_flatpak_remotes || failed=1

    if [ "$failed" -eq 0 ]; then
        echo "Flatpak 环境与源配置完成。"
        return 0
    else
        echo "Flatpak 环境或源配置存在失败项，请查看上方输出。" >&2
        return 1
    fi
}

# 命令 all：依次执行 base → flatpak-env → flatpak-apps
# 某一项失败不中断后续项；最终存在任何失败即返回非 0
run_all() {
    local rc=0

    echo "==> [base] 安装系统基础软件包"
    install_system_packages || rc=1
    echo "==> [flatpak-env] 准备 Flatpak 环境与源"
    setup_flatpak_env || rc=1
    echo "==> [flatpak-apps] 安装 Flatpak 应用"
    install_flatpak_apps || rc=1

    if [ "$rc" -eq 0 ]; then
        echo "全部命令完成。"
        return 0
    else
        echo "存在失败项，请查看上方输出后重跑对应命令。" >&2
        return 1
    fi
}

# -----------------------------------------------------------------------------
# 命令行入口
# -----------------------------------------------------------------------------

# 打印帮助说明（每个命令的含义）
_usage() {
    cat <<'EOF'
用法: bash cmd [命令 ...]

可用命令（可一次传入多个，按顺序依次执行；不传任何参数时显示本帮助）:
  info          检测并显示当前系统信息（不会安装任何东西）
  base          通过系统包管理器安装基础软件包（见头部 SYSTEM_PACKAGES）
  flatpak-env   安装 Flatpak 运行时，并批量配置 FLATPAK_REMOTES 中列出的源
  flatpak-apps  按 FLATPAK_APPS 清单批量安装 Flatpak 应用
                （清单格式为 <remote>|<应用ID>；需先执行过 flatpak-env）
  all           依次执行: base → flatpak-env → flatpak-apps
  help          显示本帮助

示例:
  bash eron-system-rebuild-2026.sh info
  bash eron-system-rebuild-2026.sh base
  bash eron-system-rebuild-2026.sh flatpak-env
  bash eron-system-rebuild-2026.sh flatpak-apps
  bash eron-system-rebuild-2026.sh all

作为函数库使用（source 引入后可直接调用）:
  detect_os / print_os_info           系统检测与信息打印
  install_package <包名>              安装系统软件包（幂等）
  add_flatpak_remote <名称> <地址> [优先级] [镜像URL]
                                      添加单个 Flatpak 源（值由上层指定）
  install_flatpak_app <remote> <应用ID>
                                      从指定源安装单个 Flatpak 应用（幂等）
  install_system_packages / setup_flatpak_env / install_flatpak_apps
                                      base / flatpak-env / flatpak-apps 的等价函数
  find_files_by_keywords <目录> <后缀> <关键字...>
                                      查找文件工具
EOF
}

# 校验系统是否受支持；通过后再执行给定的命令函数
# 用法：_require_supported <函数名>
_require_supported() {
    if [ "$OS_SUPPORTED" -ne 1 ]; then
        echo "当前系统不支持自动安装：需要 apt（Debian/Ubuntu/衍生）或 dnf（Fedora/衍生）。" >&2
        print_os_info
        return 2
    fi
    "$@"
}

main() {
    detect_os

    # 仅当「直接运行」时才进入命令行分发；以 source 方式引入时只暴露函数
    if [ "${BASH_SOURCE[0]}" = "$0" ]; then
        if [ "$#" -eq 0 ]; then
            _usage
            exit 0
        fi

        local cmd rc=0
        for cmd in "$@"; do
            case "$cmd" in
                help|-h|--help)
                    _usage
                    ;;
                info)
                    print_os_info
                    ;;
                base)
                    _require_supported install_system_packages || rc=1
                    ;;
                flatpak-env)
                    _require_supported setup_flatpak_env || rc=1
                    ;;
                flatpak-apps)
                    _require_supported install_flatpak_apps || rc=1
                    ;;
                all)
                    _require_supported run_all || rc=1
                    ;;
                *)
                    echo "错误: 未知命令 '$cmd'（运行 help 查看可用命令）" >&2
                    rc=2
                    ;;
            esac
        done
        exit $rc
    fi
}

main "$@"
