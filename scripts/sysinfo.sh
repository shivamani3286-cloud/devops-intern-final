#!/bin/bash
# sysinfo.sh - prints basic system info

echo "===== Current User ====="
whoami

echo ""
echo "===== Current Date ====="
date

echo ""
echo "===== Disk Usage ====="
df -h
