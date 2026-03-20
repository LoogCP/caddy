# 🚀 Custom Caddy Build · 可自定义Caddy插件

[![构建状态](https://github.com/LoogCP/caddy/actions/workflows/build-caddy.yml/badge.svg)](https://github.com/LoogCP/caddy/actions)
[![最新版本](https://img.shields.io/github/v/release/LoogCP/caddy)](https://github.com/LoogCP/caddy/releases/latest)

这是一个自动化构建项目，旨在利用GitHub Actions编译带自定义插件的Caddy二进制文件，无需搭建go编译环境，只需要将preset-caddy.sh加入到OpenWrt/immortalwrt编译流程中，即可编译带caddy二进制包的固件。亦可从 [Releases](https://github.com/LoogCP/caddy/releases/latest) 页面直接下载。

---

### 解决了什么问题？

官方发布的 Caddy 不包含任何 DNS 插件。若要使用 DNS 提供商（如 Cloudflare）来自动申请泛域名或内网站点的 HTTPS 证书，用户必须自行下载 Caddy 源码和插件源码，并使用 `xcaddy` 进行编译。这个过程不仅繁琐，而且每次 Caddy 更新都需要重复操作。

**本仓库通过 GitHub Actions 将这一过程完全自动化，为您提供一个开箱即用的解决方案。**

---

### ⚡ 如何使用

1. 检查plugins.list中插件是否包含你想要的，如果没有，则fork后修改plugins.list文件，修改preset-caddy.sh文件的REPO变量
2. 在编译OpenWrt/immortalwrt流程中执行preset-caddy.sh（make之前）
3. 初次刷入或不保留配置刷入带此caddy的固件后，需要先ssh进入路由器，编辑Caddyfile中的配置，停止并禁用*uhttpd/nginx*后重启caddy
4. 我正在无故障使用中，任何问题请善用AI。I am currently operating without any faults. If you encounter any issues, please refer to AI.

---

### ❓why caddy

caddy可通过内置模块直接实现使用acme申请ssl证书，实现https访问（好像现在Nginx也可以），OpenWrt的luci-app-acme有问题，通常无法正确申请到证书。

---

### 🛠️ 工作原理

本仓库使用 GitHub Actions 自动化执行以下任务：

1.  **每日检查**：定时任务每月触发，访问 Caddy 官方仓库 API，获取最新的版本号。
2.  **版本比对**：检查本地仓库是否已存在该版本号的 Release。如果存在，则跳过本次任务。
3.  **交叉编译**：如果发现新版本，则启动构建任务，使用 `xcaddy` 为 `linux/amd64`交叉编译 Caddy。
4.  **插件验证**：在编译 `amd64` 版本后，会**严格执行验证步骤**，确保 Cloudflare 插件已成功集成。如果验证失败，构建将中止。
5.  **打包发布**：将编译好的二进制文件和 SHA256 校验和打包，并创建一个与官方版本号一致的 GitHub Release。

### 致谢

- [Caddy](https://github.com/caddyserver/caddy)
- [xcaddy](https://github.com/caddyserver/xcaddy)
- [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
- [qichiyuhub/caddy-cloudflare](https://github.com/qichiyuhub/caddy-cloudflare)
