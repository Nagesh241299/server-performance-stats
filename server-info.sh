#!/bin/bash

# Define output file
OUTPUT="server_report_$(date +%F_%T).txt"

echo "Generating server report... 📝"

# OS and Version
echo "===== OS & Version =====" >> $OUTPUT
lsb_release -a 2>/dev/null >> $OUTPUT
cat /etc/os-release >> $OUTPUT
uname -a >> $OUTPUT
echo "" >> $OUTPUT

# CPU Info
echo "===== CPU Info =====" >> $OUTPUT
lscpu >> $OUTPUT
echo "" >> $OUTPUT

# Memory (RAM)
echo "===== Memory Info =====" >> $OUTPUT
free -h >> $OUTPUT
echo "" >> $OUTPUT

# Disk Storage
echo "===== Disk Storage =====" >> $OUTPUT
lsblk >> $OUTPUT
df -h >> $OUTPUT
echo "" >> $OUTPUT

# IP Addresses
echo "===== IP Addresses =====" >> $OUTPUT
echo "Private IP(s):" >> $OUTPUT
hostname -I >> $OUTPUT
echo "Public IP:" >> $OUTPUT
curl -s ifconfig.me >> $OUTPUT
echo "" >> $OUTPUT

# Network Interfaces
echo "===== Network Interfaces =====" >> $OUTPUT
ip a >> $OUTPUT
echo "" >> $OUTPUT

# Mounted File Systems
echo "===== Mounted Filesystems =====" >> $OUTPUT
mount | column -t >> $OUTPUT
echo "" >> $OUTPUT

# Uptime
echo "===== Uptime =====" >> $OUTPUT
uptime >> $OUTPUT
echo "" >> $OUTPUT

# Full System Summary
echo "===== Full System Summary (lshw -short) =====" >> $OUTPUT
sudo lshw -short >> $OUTPUT
echo "" >> $OUTPUT

# Disk Usage per Directory
echo "===== Disk Usage per Directory =====" >> $OUTPUT
sudo du -sh /* 2>/dev/null >> $OUTPUT
echo "" >> $OUTPUT

# Installed Packages
echo "===== Installed Packages =====" >> $OUTPUT
dpkg -l >> $OUTPUT
echo "" >> $OUTPUT

echo "✅ Server report generated: $OUTPUT"
