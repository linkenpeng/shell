#!/bin/bash
echo "===== 开始清理Mac系统数据（安全清理） ====="
echo "1. 删除APFS本地Time Machine快照（占用系统数据大头）"
sudo tmutil deletelocalsnapshots /

echo -e "\n2. 清理pip全局缓存"
pip cache purge

echo -e "\n3. 清理系统临时目录 /private/var/folders"
sudo rm -rf /private/var/folders/*

echo -e "\n4. 清理系统日志"
sudo rm -rf /private/var/log/*

echo "===== 清理前磁盘状态 ====="

df -h /

# ---------- 1. 应用缓存（自动重建，安全） ----------
rm -rf "$HOME/Library/Caches/vscode-cpptools"
rm -rf "$HOME/Library/Caches/JetBrains"
rm -rf "$HOME/Library/Caches/Google"
rm -rf "$HOME/Library/Caches/com.tencent.workbuddy.mac.BundleMigration"
rm -rf "$HOME/Library/Caches/Citro Labs"
rm -rf "$HOME/Library/Caches/node-gyp"
rm -rf "$HOME/Library/Caches/go-build"
echo "[1/6] 应用缓存清理完成"

# ---------- 2. 用户日志（仅删 30 天前 + 超 10M 的大日志）----------
# 注：部分日志可能被系统安全中心拦截，属正常现象，跳过即可
find "$HOME/Library/Logs" -type f -name "*.log" -mtime +30 -delete 2>/dev/null
find "$HOME/Library/Logs" -type f -size +10M -delete 2>/dev/null
echo "[2/6] 旧日志清理完成"

# ---------- 3. 包管理器缓存 ----------
npm cache clean --force 2>/dev/null
pnpm store prune 2>/dev/null          # 只清未被引用的包，不碰项目硬链接
go clean -modcache 2>/dev/null
echo "[3/6] npm / pnpm / go 缓存清理完成"

# ---------- 4. 特定残留 ----------
rm -rf "$HOME/Library/Ethash"                              # 以太坊挖矿 DAG 缓存
rm -rf "$HOME/Library/Trial"                               # 试用残留
rm -rf "$HOME/Library/Application Support/DingTalkMac"     # 钉钉卸载残留
echo "[4/6] Ethash / Trial / 钉钉残留清理完成"

# ---------- 5. JetBrains 旧版本残留（保留当前在用的 2025.2）----------
rm -rf "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.1"
rm -rf "$HOME/Library/Application Support/JetBrains/IntelliJIdea2023.3"
echo "[5/6] JetBrains 旧版本残留清理完成"

# ---------- 6. VSCode 缓存 + 不活跃项目 node_modules ----------
rm -rf "$HOME/Library/Application Support/Code/CachedExtensionVSIXs"
rm -rf "$HOME/Library/Application Support/Code/Cache"
rm -rf "$HOME/Library/Application Support/Code/CachedData"
rm -rf "$HOME/Library/Application Support/Code/logs"

# 不活跃项目的 node_modules（需要时进项目跑 pnpm install / npm install 恢复）
rm -rf "$HOME/project/gitee/intmall/intmall-ui-mobile/node_modules"
rm -rf "$HOME/project/gitee/intmall/intmall-ui-admin/node_modules"
rm -rf "$HOME/project/gitee/tokenhub/frontend/node_modules"
rm -rf "$HOME/project/html/Excalidraw/node_modules"
echo "[6/6] VSCode 缓存 + node_modules 清理完成"

echo "===== 清理后磁盘状态 ====="
df -h /
echo "全部完成 ✅"
