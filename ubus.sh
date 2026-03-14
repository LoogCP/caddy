#!/bin/sh
# /etc/caddy/ubus.sh - 最简单的 ubus CGI 代理

# 设置正确的 ubus socket 路径
UBUS_SOCKET="/var/run/ubus/ubus.sock"

# 提取 ubus 路径（移除 /ubus 前缀）
PATH_INFO="${SCRIPT_NAME#/ubus}"

# 调用 ubus
ubus -S call $PATH_INFO "$(cat 2>/dev/null || echo '{}')"
