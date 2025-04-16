#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

separator="================================================================================"

print_header() {
    echo -e "\n${CYAN}${BOLD}$1${RESET}"
    echo "$separator"
}

# ------------------------ CPU Usage ------------------------

top_output=$(top -bn1)

cpu_idle=$(echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { printf("%.1f", 100 - idle) }')

print_header "🖥️  CPU Usage"
echo -e "Usage         : ${GREEN}${cpu_usage}%${RESET}"


echo "***************************************************************************************"

# Memory
# Read memory from file

read total_memory available_memory <<< $(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)

used_memory=$((total_memory - available_memory))
used_memory_percent=$(awk -v u=$used_memory -v t=$total_memory 'BEGIN { printf("%.1f", (u / t) * 100) }')
free_memory_percent=$(awk -v a=$available_memory -v t=$total_memory 'BEGIN { printf("%.1f", (a / t) * 100) }')

# Convert from kB to MB 
total_memory_mb=$(awk -v t=$total_memory 'BEGIN { printf("%.1f", t/1024) }')
used_mb=$(awk -v u=$used_memory 'BEGIN { printf("%.1f", u/1024) }')
available_memory_mb=$(awk -v a=$available_memory 'BEGIN { printf("%.1f", a/1024) }')

echo "Total Memory    : $total_memory_mb MB"
echo "Used Memory     : $used_mb MB ($used_memory_percent%)"
echo "Free/Available  : $available_memory_mb MB ($free_memory_percent%)"


echo "***************************************************************************************"

# Disk

df_output=$(df -h /)

size_disk=$(echo "$df_output" | awk 'NR==2 {printf $2}')

# Dont use printf in below line, it doesnt add space
read used_disk available_disk <<< $(echo "$df_output" | awk 'NR==2 {print $3, $4}')

df_output_raw=$(df /)

read size_disk_kb used_disk_kb available_disk_kb <<< $(echo "$df_output_raw" | awk 'NR==2 {print $2, $3, $4}')

used_disk_percent=$(echo "scale=2; $used_disk_kb *100/$size_disk_kb" | bc)
available_disk_percent=$(echo "scale=2; $available_disk_kb *100/$size_disk_kb" | bc)

echo "Disk Size : $size_disk"
echo "Used Disk Space: $used_disk ($used_disk_percent%)"
echo "Available Disk Space: $available_disk ($available_disk_percent)"

echo "***************************************************************************************"

# Top Processes by CPU and Memory

top_5_processes_by_cpu=$(ps aux --sort -%cpu | head -6)
top_5_processes_by_memory=$(ps aux --sort -%mem | head -6)

echo "TOP 5 processes consuming CPU:"
printf "\n"
echo "$top_5_processes_by_cpu"

echo "***************************************************************************************"

echo "TOP 5 processes consuming Memory:" 
printf "\n"
echo "$top_5_processes_by_memory"