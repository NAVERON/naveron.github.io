
# 脚本学习和应用

> 作者：WANGYULONG / ERON

## 一些命令行工具

- `jq`, which is a `json parse` shell tool, the offical site : [JQ - A JSON SHELL TOOL](https://stedolan.github.io/jq/)
- `panda`, a VPN tool to browse World, need pay for that
- `repo` script, google muti git repositories manager script, can clone a bundle git repos

## 一些脚本

> Let life be beautiful like summer flowers And death like autumn leaves  

### linux初始化环境脚本

> 这是一份比较偏“开发环境一键初始化”的脚本笔记，重点是把常用开发工具、环境变量和基础配置整理成可重复执行的流程  

> 第一次写环境重建的脚本，不是很成功，没有做后期验证：<a href="../../resource/files/sys-config-shell.sh" download>初次尝试独自实现脚本</a>  
> 后来，有时间，使用AI重新将上述的脚本使用python实现: <a href="../../resource/files/system-rebuild-python.py" download>debian系、rh系重装脚本-python实现的版本</a>  
> 后面又重新尝试了各种系统和工具，借助AI实现了一个相对完整的环境重建脚本工具：[环境重建漫谈](daily/env-rebuild.md#二、「经验」脚本)  

### 服务管理脚本

> 开发过程中需要需要许多配套服务运行，脚本一键多服务环境启动：<a href="../../resource/files/services-manager-shell.sh" download>多服务管理脚本</a>  
> 当前由`podman/docker compse`技术替代：具体实现见：[容器技术漫谈](container-tech-learning.md)  

### vim 配置

> vim 基础配置：<a href="../../resource/files/vim-config.sh" download>vim配置文件</a>  

### `python`实现的自动邮件发送脚本

> 起初借助gist脚本和自己修改实现，现在借助AI优化：<a href="../../resource/files/cli-mail-cmd-old.py" download>python实现的邮件发送脚本</a>  
> 优化后如下，未实际测试验证  

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# This little project is hosted at: <https://gist.github.com/1455741>
# Copyright 2011-2020 Álvaro Justen [alvarojusten at gmail dot com]
# License: GPL <http://www.gnu.org/copyleft/gpl.html>

"""Send text or HTML email from the command line or another Python program."""

from __future__ import annotations

import argparse
import getpass
import mimetypes
import os
import smtplib
import ssl
from email.message import EmailMessage
from email.utils import formataddr, getaddresses
from pathlib import Path
from typing import Iterable, Sequence


def parse_addresses(values: str | Iterable[str]) -> list[tuple[str, str]]:
    """Parse comma-separated address values into display-name/address pairs."""
    if isinstance(values, str):
        values = [values]

    normalized = [value.replace(";", ",") for value in values if value]
    addresses = getaddresses(normalized)
    invalid = [address for _, address in addresses if "@" not in address]
    if invalid:
        raise ValueError(f"Invalid email address: {', '.join(invalid)}")
    return [(name.strip(), address.strip()) for name, address in addresses]


def format_addresses(values: str | Iterable[str]) -> str:
    """Return parsed addresses in a correctly encoded mail-header format."""
    return ", ".join(formataddr(item) for item in parse_addresses(values))


def read_body(body: str | None, body_file: str | None) -> str:
    if body_file:
        return Path(body_file).read_text(encoding="utf-8")
    return body or ""


def build_message(
    sender: str,
    recipients: str | Iterable[str],
    subject: str,
    body: str,
    *,
    sender_name: str | None = None,
    cc: str | Iterable[str] | None = None,
    bcc: str | Iterable[str] | None = None,
    reply_to: str | None = None,
    html_body: str | None = None,
    attachments: Sequence[str] | None = None,
) -> EmailMessage:
    """Build an email message that can be sent by any SMTP client."""
    to_addresses = parse_addresses(recipients)
    if not to_addresses:
        raise ValueError("At least one recipient is required")

    message = EmailMessage()
    message["From"] = formataddr((sender_name or "", sender))
    message["To"] = ", ".join(formataddr(item) for item in to_addresses)
    message["Subject"] = subject

    if cc:
        message["Cc"] = format_addresses(cc)
    if bcc:
        message["Bcc"] = format_addresses(bcc)
    if reply_to:
        message["Reply-To"] = format_addresses(reply_to)

    message.set_content(body)
    if html_body is not None:
        message.add_alternative(html_body, subtype="html")

    for filename in attachments or []:
        path = Path(filename)
        if not path.is_file():
            raise FileNotFoundError(f"Attachment not found: {filename}")

        content_type, _ = mimetypes.guess_type(path.name)
        maintype, subtype = (content_type or "application/octet-stream").split(
            "/", 1
        )
        message.add_attachment(
            path.read_bytes(),
            maintype=maintype,
            subtype=subtype,
            filename=path.name,
        )

    return message


def send_email(
    message: EmailMessage,
    *,
    smtp_host: str,
    smtp_port: int = 587,
    username: str | None = None,
    password: str | None = None,
    security: str = "starttls",
    timeout: float = 30,
) -> dict[str, tuple[int, bytes]]:
    """Send a prepared message using plain SMTP, STARTTLS, or SMTP over SSL."""
    if security not in {"plain", "starttls", "ssl"}:
        raise ValueError("security must be plain, starttls, or ssl")

    context = ssl.create_default_context()
    if security == "ssl":
        connection = smtplib.SMTP_SSL(
            smtp_host, smtp_port, timeout=timeout, context=context
        )
    else:
        connection = smtplib.SMTP(smtp_host, smtp_port, timeout=timeout)

    with connection:
        connection.ehlo()
        if security == "starttls":
            connection.starttls(context=context)
            connection.ehlo()
        if username:
            if password is None:
                raise ValueError("A password is required when username is provided")
            connection.login(username, password)
        return connection.send_message(message)


def create_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Send an email with SMTP.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("-f", "--from", dest="sender", required=True)
    parser.add_argument("--sender-name", default="")
    parser.add_argument("-t", "--to", dest="recipients", required=True)
    parser.add_argument("--cc")
    parser.add_argument("--bcc")
    parser.add_argument("--reply-to")
    parser.add_argument("-s", "--subject", default="")
    parser.add_argument("-m", "--message", dest="body", default="")
    parser.add_argument("--body-file")
    parser.add_argument("--html-file")
    parser.add_argument("-x", "--attachment", action="append", default=[])
    parser.add_argument("--smtp-host", default=os.getenv("SMTP_HOST", "localhost"))
    parser.add_argument("--smtp-port", type=int, default=None)
    parser.add_argument(
        "--security",
        choices=("plain", "starttls", "ssl"),
        default=os.getenv("SMTP_SECURITY", "starttls"),
    )
    parser.add_argument("--username", default=None)
    parser.add_argument("--password-env", default="SMTP_PASSWORD")
    parser.add_argument("--timeout", type=float, default=30)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = create_parser()
    args = parser.parse_args(argv)

    default_ports = {"plain": 25, "starttls": 587, "ssl": 465}
    smtp_port = args.smtp_port or default_ports[args.security]
    username = args.username or args.sender
    password = os.getenv(args.password_env)
    if password is None:
        password = getpass.getpass("SMTP password: ")

    message = build_message(
        sender=args.sender,
        sender_name=args.sender_name,
        recipients=args.recipients,
        cc=args.cc,
        bcc=args.bcc,
        reply_to=args.reply_to,
        subject=args.subject,
        body=read_body(args.body, args.body_file),
        html_body=read_body(None, args.html_file) if args.html_file else None,
        attachments=args.attachment,
    )
    refused = send_email(
        message,
        smtp_host=args.smtp_host,
        smtp_port=smtp_port,
        username=username,
        password=password,
        security=args.security,
        timeout=args.timeout,
    )
    if refused:
        parser.error(f"Some recipients were refused: {', '.join(refused)}")
    print("Email sent successfully.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
```
