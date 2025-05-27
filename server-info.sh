#!/bin/bash

echo "===== OS & Kernel ====="
lsb_release -d
uname -r

echo -e "\n===== CPU Info ====="
lscpu | grep 'Model name\|CPU(s):' | uniq

echo -e "\n===== Memory (RAM) ====="
free -h

echo -e "\n===== Disk Storage ====="
df -h | grep '^/dev/'

echo -e "\n===== Private IP Address ====="
hostname -I

echo -e "\n===== Public IP Address ====="
curl -s ifconfig.me

echo -e "\n===== Uptime ====="
uptime -p
