#!/usr/bin/env python3
"""跨 Debian/Ubuntu/Fedora 系统的环境重建辅助程序。

本文件既可以作为命令行程序运行，也可以 import 后调用其中的公开函数。
安装操作默认通过 sudo 执行；请在运行安装命令前确认当前用户有 sudo 权限。
"""

from __future__ import annotations

import argparse
import os
import platform
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Optional, Sequence


# =============================================================================
# 可配置数据区
# =============================================================================

@dataclass(frozen=True)
class PackageSpec:
    package: str
    commands: tuple[str, ...]


# package 是包管理器中的名称，commands 是安装完成后用于检测的命令。
SYSTEM_PACKAGES = (
    PackageSpec("git", ("git",)),
    PackageSpec("maven", ("mvn",)),
    PackageSpec("python3", ("python3",)),
    PackageSpec("python3-pip", ("pip3", "pip")),
)

@dataclass(frozen=True)
class FlatpakRemote:
    name: str
    repo_url: str
    priority: Optional[int] = 10
    mirror_url: str = ""


FLATPAK_REMOTES = (
    FlatpakRemote(
        "flathub",
        "https://dl.flathub.org/repo/flathub.flatpakrepo",
        10,
        "https://mirrors.cernet.edu.cn/flathub",
    ),
    FlatpakRemote(
        "flatpark",
        "https://dl.flatpark.org/flatpark.flatpakrepo",
        5,
    ),
)

FLATPAK_APPS = (
    ("flathub", "com.cloudchewie.cloudotp"),
    ("flathub", "org.localsend.localsend_app"),
)


# =============================================================================
# 系统检测
# =============================================================================

OS_NAME = "Unknown"
OS_ID = ""
OS_VERSION = ""
OS_CODENAME = ""
KERNEL_NAME = "Unknown"
KERNEL_VERSION = "Unknown"
ARCH = "Unknown"
PLATFORM = ""
IS_WSL = 0
PACKAGE_MANAGER = "unknown"
OS_SUPPORTED = 0


def _read_os_release() -> dict[str, str]:
    values: dict[str, str] = {}
    try:
        lines = Path("/etc/os-release").read_text(encoding="utf-8").splitlines()
    except OSError:
        return values

    for line in lines:
        if "=" not in line or line.startswith("#"):
            continue
        key, value = line.split("=", 1)
        values[key] = value.strip().strip('"')
    return values


def detect_os() -> None:
    """检测系统并同步更新模块变量，同时导出同名环境变量。"""
    global OS_NAME, OS_ID, OS_VERSION, OS_CODENAME
    global KERNEL_NAME, KERNEL_VERSION, ARCH, PLATFORM
    global IS_WSL, PACKAGE_MANAGER, OS_SUPPORTED

    release = _read_os_release()
    KERNEL_NAME = platform.system() or "Linux"
    KERNEL_VERSION = platform.release() or "Unknown"
    ARCH = platform.machine() or "Unknown"
    PLATFORM = f"{KERNEL_NAME}-{ARCH}"

    OS_NAME = release.get("PRETTY_NAME") or release.get("NAME") or "Linux"
    OS_ID = release.get("ID", "linux")
    OS_VERSION = release.get("VERSION_ID") or release.get("VERSION") or KERNEL_VERSION
    OS_CODENAME = release.get("VERSION_CODENAME", "")

    proc_version = Path("/proc/version")
    proc_release = Path("/proc/sys/kernel/osrelease")
    wsl_text = ""
    for path in (proc_version, proc_release):
        try:
            wsl_text += path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            pass
    IS_WSL = int("microsoft" in wsl_text.lower())

    if shutil.which("apt") or shutil.which("apt-get"):
        PACKAGE_MANAGER = "apt"
        OS_SUPPORTED = 1
    elif shutil.which("dnf"):
        PACKAGE_MANAGER = "dnf"
        OS_SUPPORTED = 1
    else:
        PACKAGE_MANAGER = "unknown"
        OS_SUPPORTED = 0

    exported = {
        "OS_NAME": OS_NAME,
        "OS_ID": OS_ID,
        "OS_VERSION": OS_VERSION,
        "OS_CODENAME": OS_CODENAME,
        "KERNEL_NAME": KERNEL_NAME,
        "KERNEL_VERSION": KERNEL_VERSION,
        "ARCH": ARCH,
        "PLATFORM": PLATFORM,
        "IS_WSL": str(IS_WSL),
        "PACKAGE_MANAGER": PACKAGE_MANAGER,
        "OS_SUPPORTED": str(OS_SUPPORTED),
    }
    os.environ.update(exported)


def print_os_info() -> None:
    for name in (
        "OS_NAME", "OS_ID", "OS_VERSION", "OS_CODENAME", "KERNEL_NAME",
        "KERNEL_VERSION", "ARCH", "PLATFORM", "IS_WSL", "PACKAGE_MANAGER",
        "OS_SUPPORTED",
    ):
        print(f"    {name}={globals()[name]}")


# =============================================================================
# 系统包管理器
# =============================================================================

_APT_UPDATE_DONE = False


def _run(command: Sequence[str], *, check: bool = False) -> subprocess.CompletedProcess[str]:
    """运行外部命令，保留输出并避免 shell 字符串拼接。"""
    try:
        result = subprocess.run(command, text=True, capture_output=True, check=check)
        if result.stdout:
            print(result.stdout, end="")
        if result.stderr:
            print(result.stderr, end="", file=sys.stderr)
        return result
    except FileNotFoundError:
        print(f"命令不存在: {command[0]}", file=sys.stderr)
        return subprocess.CompletedProcess(command, 127)
    except subprocess.CalledProcessError as error:
        if error.stdout:
            print(error.stdout, end="")
        if error.stderr:
            print(error.stderr, end="", file=sys.stderr)
        return subprocess.CompletedProcess(command, error.returncode, error.stdout, error.stderr)


def _update_manager_index() -> None:
    global _APT_UPDATE_DONE
    if PACKAGE_MANAGER != "apt" or _APT_UPDATE_DONE:
        return
    _APT_UPDATE_DONE = True
    _run(("sudo", "apt-get", "update"))


def _install_with_manager(package: str) -> int:
    if PACKAGE_MANAGER == "apt":
        _update_manager_index()
        command = ("sudo", "apt-get", "install", "-y", "--no-install-recommends", package)
    elif PACKAGE_MANAGER == "dnf":
        command = ("sudo", "dnf", "-y", "install", package)
    else:
        print(f"未知的包管理器：{PACKAGE_MANAGER}", file=sys.stderr)
        return 3
    return _run(command).returncode


def _first_available(commands: Iterable[str]) -> Optional[str]:
    return next((command for command in commands if shutil.which(command)), None)


def install_package(package: str, command: Optional[str] = None) -> int:
    """检测并安装包；command 用于处理包名与命令名不同的情况。"""
    if not package:
        print("用法: install_package <包名> [命令名]", file=sys.stderr)
        return 1

    check_command = command or package
    if shutil.which(check_command):
        print(f"程序 '{check_command}' 已安装。")
        return 0
    if OS_SUPPORTED != 1:
        print("无法自动安装：仅支持 apt/apt-get 或 dnf 系统。", file=sys.stderr)
        return 2

    print(f"程序 '{check_command}' 未安装，正在尝试安装...")
    result = _install_with_manager(package)
    if result == 0 or shutil.which(check_command):
        print(f"程序 '{check_command}' 安装成功。")
        return 0
    print(f"程序 '{check_command}' 安装失败。", file=sys.stderr)
    return 4


def install_system_packages(package_specs: Optional[Sequence[PackageSpec]] = None) -> int:
    failed = 0
    for spec in package_specs or SYSTEM_PACKAGES:
        command = _first_available(spec.commands)
        if command:
            print(f"程序 '{command}' 已安装。")
            continue
        if install_package(spec.package, spec.commands[0]) != 0:
            failed = 1
    return failed


# =============================================================================
# Flatpak
# =============================================================================


def install_flatpak_runtime() -> int:
    if shutil.which("flatpak"):
        print("Flatpak 已安装。")
        return 0
    if OS_SUPPORTED != 1:
        print("无法自动安装 Flatpak：仅支持 apt/apt-get 或 dnf 系统。", file=sys.stderr)
        return 2

    print("Flatpak 未安装，正在尝试安装...")
    result = _install_with_manager("flatpak")
    if result == 0 and shutil.which("flatpak"):
        print("Flatpak 安装成功。")
        return 0
    print("Flatpak 安装失败。", file=sys.stderr)
    return 4


def _flatpak_remotes() -> set[str]:
    result = _run(("flatpak", "remote-list", "--columns=name"))
    if result.returncode != 0:
        return set()
    return {line.strip() for line in (result.stdout or "").splitlines() if line.strip()}


def add_flatpak_remote(
    name: str, repo_url: str, priority: Optional[int] = None, mirror_url: str = ""
) -> int:
    if not name or not repo_url:
        print("用法: add_flatpak_remote <名称> <地址> [优先级] [镜像URL]", file=sys.stderr)
        return 1
    if not shutil.which("flatpak"):
        print("Flatpak 未安装，请先执行 install_flatpak_runtime。", file=sys.stderr)
        return 2

    if name in _flatpak_remotes():
        print(f"Flatpak 源 '{name}' 已存在。")
    else:
        print(f"添加 Flatpak 源 '{name}' ...")
        if _run(("flatpak", "remote-add", "--if-not-exists", name, repo_url)).returncode != 0:
            return 3

    if mirror_url and _run(("flatpak", "remote-modify", name, f"--url={mirror_url}")).returncode != 0:
        return 3
    if priority is not None and _run(("flatpak", "remote-modify", name, f"--prio={priority}")).returncode != 0:
        return 3
    print(f"Flatpak 源 '{name}' 配置完成。")
    return 0


def apply_flatpak_remotes() -> int:
    failed = 0
    if not FLATPAK_REMOTES:
        print("FLATPAK_REMOTES 为空，跳过源配置。")
        return 0
    for remote in FLATPAK_REMOTES:
        if add_flatpak_remote(remote.name, remote.repo_url, remote.priority, remote.mirror_url):
            failed = 1
    return failed


def _installed_flatpak_apps() -> set[str]:
    result = _run(("flatpak", "list", "--app", "--columns=application"))
    if result.returncode != 0:
        return set()
    return {line.strip() for line in (result.stdout or "").splitlines() if line.strip()}


def install_flatpak_app(remote: str, app_id: str) -> int:
    if not remote or not app_id:
        print("用法: install_flatpak_app <remote名称> <应用ID>", file=sys.stderr)
        return 1
    if not shutil.which("flatpak"):
        print("Flatpak 未安装，请先执行 install_flatpak_runtime。", file=sys.stderr)
        return 2
    if app_id in _installed_flatpak_apps():
        print(f"Flatpak 应用 '{app_id}' 已安装。")
        return 0

    print(f"正在从源 '{remote}' 安装 Flatpak 应用 '{app_id}' ...")
    if _run(("flatpak", "install", "-y", remote, app_id)).returncode != 0:
        print(f"Flatpak 应用 '{app_id}' 安装失败。", file=sys.stderr)
        return 3
    if app_id in _installed_flatpak_apps():
        print(f"Flatpak 应用 '{app_id}' 安装成功。")
        return 0
    print(f"Flatpak 应用 '{app_id}' 安装失败。", file=sys.stderr)
    return 3


def install_flatpak_apps(apps: Optional[Sequence[tuple[str, str]]] = None) -> int:
    failed = 0
    for remote, app_id in apps or FLATPAK_APPS:
        if install_flatpak_app(remote, app_id):
            failed = 1
    return failed


def setup_flatpak_env() -> int:
    failed = int(install_flatpak_runtime() != 0)
    failed |= int(apply_flatpak_remotes() != 0)
    if failed:
        print("Flatpak 环境或源配置存在失败项，请查看上方输出。", file=sys.stderr)
        return 1
    print("Flatpak 环境与源配置完成。")
    return 0


# =============================================================================
# 文件查找和组合命令
# =============================================================================


def find_files_by_keywords(search_dir: str, suffix: str, *keywords: str) -> list[str]:
    """在指定目录的一级文件中查找包含全部关键字且后缀匹配的文件。"""
    if not search_dir or not suffix or not keywords:
        raise ValueError("用法: find_files_by_keywords <目录> <后缀> <关键字...>")
    normalized_suffix = suffix if suffix.startswith(".") else f".{suffix}"
    directory = Path(search_dir).expanduser()
    return sorted(
        str(path)
        for path in directory.iterdir()
        if path.is_file()
        and path.name.endswith(normalized_suffix)
        and all(keyword in path.name for keyword in keywords)
    )


def run_all(
    *,
    package_specs: Optional[Sequence[PackageSpec]] = None,
    apps: Optional[Sequence[tuple[str, str]]] = None,
    skip_base: bool = False,
    skip_flatpak_env: bool = False,
    skip_flatpak_apps: bool = False,
) -> int:
    result = 0
    if not skip_base:
        print("==> [base] 安装系统基础软件包")
        result |= int(install_system_packages(package_specs) != 0)
    if not skip_flatpak_env:
        print("==> [flatpak-env] 准备 Flatpak 环境与源")
        result |= int(setup_flatpak_env() != 0)
    if not skip_flatpak_apps:
        print("==> [flatpak-apps] 安装 Flatpak 应用")
        result |= int(install_flatpak_apps(apps) != 0)
    print("全部命令完成。" if result == 0 else "存在失败项，请查看上方输出后重跑对应命令。")
    return result


def _require_supported(function) -> int:
    if OS_SUPPORTED != 1:
        print("当前系统不支持自动安装：需要 apt/apt-get 或 dnf。", file=sys.stderr)
        print_os_info()
        return 2
    return function()


def _parse_app(value: str) -> tuple[str, str]:
    """解析 --app 的 remote|application_id 参数。"""
    remote, separator, app_id = value.partition("|")
    if not separator or not remote or not app_id:
        raise argparse.ArgumentTypeError(
            "应用格式必须是 REMOTE|APPLICATION_ID，例如 flathub|org.localsend.localsend_app"
        )
    return remote, app_id


def _select_packages(
    package_names: Optional[Sequence[str]], parser: argparse.ArgumentParser
) -> Optional[tuple[PackageSpec, ...]]:
    if not package_names:
        return None

    configured = {spec.package: spec for spec in SYSTEM_PACKAGES}
    selected: list[PackageSpec] = []
    for package in package_names:
        if package in configured:
            selected.append(configured[package])
        else:
            selected.append(PackageSpec(package, (package,)))
    return tuple(selected)


def _build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="跨 Debian/Ubuntu/Fedora 系统的环境重建辅助程序。",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""常用示例:
  %(prog)s info
  %(prog)s base --package git --package maven
  %(prog)s flatpak-apps --app flathub|org.localsend.localsend_app
  %(prog)s all --skip-flatpak-apps

默认配置来自脚本顶部的 SYSTEM_PACKAGES、FLATPAK_REMOTES 和 FLATPAK_APPS。
安装操作默认通过 sudo 执行；本程序仅使用 Python 标准库，无需额外安装依赖。""",
    )
    parser.add_argument("--version", action="version", version="%(prog)s 1.0")
    subparsers = parser.add_subparsers(dest="command", metavar="COMMAND")

    info_parser = subparsers.add_parser("info", help="显示系统检测信息，不执行安装")
    info_parser.set_defaults(handler="info")

    base_parser = subparsers.add_parser(
        "base", help="安装基础系统软件包（默认使用 SYSTEM_PACKAGES）"
    )
    base_parser.add_argument(
        "--package", dest="packages", action="append", metavar="PACKAGE",
        help="指定要安装的包名；可重复使用，未指定时使用默认清单",
    )
    base_parser.set_defaults(handler="base")

    env_parser = subparsers.add_parser(
        "flatpak-env", help="安装 Flatpak 运行时并配置软件源"
    )
    env_parser.set_defaults(handler="flatpak-env")

    apps_parser = subparsers.add_parser(
        "flatpak-apps", help="安装 Flatpak 应用（默认使用 FLATPAK_APPS）"
    )
    apps_parser.add_argument(
        "--app", dest="apps", action="append", type=_parse_app,
        metavar="REMOTE|APPLICATION_ID",
        help="指定应用来源和 ID，例如 flathub|org.localsend.localsend_app；可重复使用",
    )
    apps_parser.set_defaults(handler="flatpak-apps")

    all_parser = subparsers.add_parser(
        "all", help="依次执行 base、flatpak-env 和 flatpak-apps"
    )
    all_parser.add_argument(
        "--package", dest="packages", action="append", metavar="PACKAGE",
        help="覆盖 base 的默认包清单；可重复使用",
    )
    all_parser.add_argument(
        "--app", dest="apps", action="append", type=_parse_app,
        metavar="REMOTE|APPLICATION_ID",
        help="覆盖 flatpak-apps 的默认清单；可重复使用",
    )
    all_parser.add_argument(
        "--skip-base", action="store_true", help="跳过基础系统软件包安装"
    )
    all_parser.add_argument(
        "--skip-flatpak-env", action="store_true", help="跳过 Flatpak 环境和源配置"
    )
    all_parser.add_argument(
        "--skip-flatpak-apps", action="store_true", help="跳过 Flatpak 应用安装"
    )
    all_parser.set_defaults(handler="all")

    return parser


def main(argv: Optional[Sequence[str]] = None) -> int:
    detect_os()
    parser = _build_argument_parser()
    args = parser.parse_args(sys.argv[1:] if argv is None else argv)
    if args.command is None:
        parser.print_help()
        return 0

    if args.handler == "info":
        print_os_info()
        return 0
    if args.handler == "base":
        selected = _select_packages(args.packages, parser)
        return _require_supported(lambda: install_system_packages(selected))
    if args.handler == "flatpak-env":
        return _require_supported(setup_flatpak_env)
    if args.handler == "flatpak-apps":
        apps = tuple(args.apps) if args.apps else None
        return _require_supported(lambda: install_flatpak_apps(apps))
    if args.handler == "all":
        selected = _select_packages(args.packages, parser)
        apps = tuple(args.apps) if args.apps else None
        return _require_supported(
            lambda: run_all(
                package_specs=selected,
                apps=apps,
                skip_base=args.skip_base,
                skip_flatpak_env=args.skip_flatpak_env,
                skip_flatpak_apps=args.skip_flatpak_apps,
            )
        )
    parser.error("未识别的命令")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
