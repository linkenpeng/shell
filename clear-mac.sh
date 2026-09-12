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

echo -e "\n✅ 清理完成！请重启Mac，再查看储存空间"


