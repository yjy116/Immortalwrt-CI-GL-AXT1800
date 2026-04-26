#!/bin/bash
# 自动检测固件大小并显示 NAND 剩余空间
FW=$(find bin/targets -name '*.bin' -print -quit)
if [ -z "$FW" ]; then
  echo "未找到固件文件。"
  exit 0
fi
SIZE=$(stat -c%s "$FW")
MB=$((SIZE/1024/1024))
echo "固件大小: ${MB} MB"
TOTAL=256
REMAIN=$((TOTAL-MB))
echo "NAND 剩余空间（估算）: ${REMAIN} MB"
