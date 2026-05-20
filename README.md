
# OpenWRT-CI for GL.iNet AXT1800  

## GitHub Actions Cache 清理

GitHub Actions cache 会在仓库达到配额后自动按最近访问时间淘汰旧缓存。一般不需要频繁清理；只有在缓存接近配额、构建经常保存新缓存失败、或调整了缓存策略后，才建议手动清理。

本仓库提供 `.github/workflows/Cache-Clean.yml`，它是手动触发的安全清理流程：

- 默认 `DRY_RUN=true`，只预览候选缓存，不删除。
- 默认只匹配 `AXT1800-` 前缀，避免误删其它用途缓存。
- 默认保留最近 `8` 个匹配缓存。
- 默认只删除超过 `21` 天未访问的匹配缓存。
- 清理结果会写入 workflow 的 Summary，包含候选缓存数量和预计释放空间。

使用步骤：

1. 进入 GitHub 仓库的 `Actions` 页面。
2. 选择 `Cache-Clean` workflow。
3. 点击 `Run workflow`。
4. 第一次保持 `DRY_RUN=true`，检查 Summary 中的候选列表。
5. 确认候选列表无误后，再次运行并设置 `DRY_RUN=false` 执行删除。

建议参数：

| 参数 | 建议值 | 说明 |
|------|--------|------|
| `DRY_RUN` | `true` | 先预览，确认后再改为 `false` |
| `KEEP_LATEST` | `8` | 至少保留最近 8 个匹配缓存 |
| `MAX_AGE_DAYS` | `21` | 只清理 21 天前的旧缓存 |
| `KEY_PREFIX` | `AXT1800-` | 限定只清理本项目缓存 |

---
云编译 GL.iNet AXT1800（Slate AX）固件｜OpenWrt / ImmortalWrt 自动化构建系统

---

## 📌 项目简介

这是一个自动化 GitHub Actions 项目，用于：

- 自动编译 OpenWrt / ImmortalWrt AXT1800 固件  
- 支持自动更新、自动打包  
- 自动检测固件大小与 NAND 剩余空间  
- 提供可直接从 GL 官方固件刷入的 sysupgrade.bin  
- 支持 U-Boot recovery（192.168.1.1）刷机  

适合：  
✔ 爱折腾 OpenWrt 的高级用户  
✔ 需要自动化构建固件的开发者  
✔ 使用 AXT1800 作为旁路/主路由的技术玩家  

---

# ✨ 特性一览

- 自动云编译（手动 / 定时 / 自动触发）
- 支持插件定制
- 自动检测固件大小与 NAND 剩余空间
- 兼容 GL 官方固件直接刷入
- 完整系统日志输出
- 干净可维护的 CI 框架

---

# 🛠 硬件规格（AXT1800）

## 📌 中文版

- **CPU**：Qualcomm IPQ6000 四核 1.2GHz  
- **内存**：512MB  
- **闪存**：256MB NAND  
- **WiFi 规格**：  
  - 2.4GHz：574Mbps（WiFi 6）  
  - 5GHz：1201Mbps（WiFi 6）  
  - 支持 OFDMA + MU-MIMO  
- **端口**：  
  - 2 × 千兆 LAN  
  - 1 × USB 3.0  
- **特点**：旅行路由、小型家庭路由、科学上网专机  
- **支持**：OpenWrt / ImmortalWrt / GL.iNet 官方固件  
- **加速**：NSS / FastPath 支持（补丁可启用）  

---

## 📌 English Version

- **CPU**: Qualcomm IPQ6000 Quad-Core 1.2GHz  
- **RAM**: 512MB  
- **Flash**: 256MB NAND  
- **WiFi**:  
  - 2.4GHz: 574Mbps (WiFi 6)  
  - 5GHz: 1201Mbps (WiFi 6)  
  - OFDMA + MU-MIMO  
- **Ports**:  
  - 2 × Gigabit LAN  
  - 1 × USB 3.0  
- **Highlights**: Travel router / Home WiFi6 / Proxy gateway  
- **Supports**: OpenWrt, ImmortalWrt, GL.iNet Firmware  
- **Acceleration**: NSS, FastPath capable  

---

# 🔥 固件说明

构建系统会自动生成：

| 文件 | 说明 |
|------|------|
| `sysupgrade.bin` | 用于 GL 官方固件 / OpenWrt 的直接刷机 |
| `kernel.bin` | 开发者使用 |
| `rootfs.bin` | 开发者使用 |
| `rootfs.tar.gz` | Recovery / 解包用 |
| `sha256sums` | 校验信息 |

⚠ **AXT1800 不生成 factory.bin，是正常行为！**  
GL 官方固件原生支持 sysupgrade 格式，无需 factory。

---

# 📥 下载 GL 官方固件（factory.img）

用于恢复 / 降级 / 解砖：

🔗 https://dl.gl-inet.com/firmware/axt1800/release/

示例文件：

- `gl-axt1800-4.x.x-stable.bin`  
- `gl-axt1800-4.x.x-factory.img`

---

# 🚀 从 GL 官方固件刷入本项目固件（教程）

## Step 1：登录官方管理界面

浏览器输入：

```
http://192.168.8.1
```

---

## Step 2：进入“固件升级”页面

路径：

```
高级设置（Advanced） → 固件升级（Firmware Upgrade）
```

---

## Step 3：上传 sysupgrade.bin

选择：

```
openwrt-qualcommax-ipq60xx-glinet_gl-axt1800-squashfs-nand-sysupgrade.bin
```

⚠ **请务必取消 “保留配置（Keep Settings）”**

---

## Step 4：等待设备自动重启

约 **2–3 分钟**，设备自动重启。

---

## Step 5：登录 OpenWrt

```
http://192.168.8.1
```

进入 LuCI 即刷机成功。

---

# 🆘 救砖教程（U-Boot Recovery）

1. 断电  
2. 按住 Reset  
3. 通电  
4. 继续按住 10 秒直到 LED 快速闪烁  
5. 访问：

```
http://192.168.1.1
```

上传官方 `factory.img` 即可恢复。

---

# 📊 自动检测固件大小与 NAND 剩余空间（CI 已集成）

脚本：

```
Scripts/check_space.sh
```

编译结束后会自动输出：

```
固件大小: XX MB
NAND 剩余空间（估算）: XXX MB
```

---

# 🧩 项目结构

```
Config/
  ├─ AXT1800.txt
  ├─ GENERAL.txt
Scripts/
  ├─ Settings.sh
  ├─ check_space.sh
.github/
  ├─ workflows/
       ├─ AXT1800.yml
       ├─ AXT1800-TEST.yml
       ├─ Auto-Build.yml
       ├─ WRT-CORE.yml
```

---

# 🌐 English Quick Guide

## How to flash:

1. Open `http://192.168.8.1`  
2. Go to **Advanced → Firmware Upgrade**  
3. Upload the `sysupgrade.bin`  
4. Uncheck **Keep Settings**  
5. Wait for reboot  
6. Login at `http://192.168.8.1`

Recovery:

- Hold Reset while powering on → `http://192.168.1.1`

---
