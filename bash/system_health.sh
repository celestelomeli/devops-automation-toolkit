#!/usr/bin/env bash

set -euo pipefail

echo "=== System Health Check ==="

# --- Disk Usage ---

# disk_percent=$(df -h / | tail -n 1 | awk '{print $5}')
# disk_used=$(df -h / | tail -n 1 | awk '{print $3}')
# disk_total=$(df -h / | tail -n 1 | awk '{print $2}')
# echo "Disk Usage: $disk_percent"
# echo "Disk Used: $disk_used"
# echo "Disk Total: $disk_total"

disk_info=$(df -h / | tail -n 1)
disk_percent=$(echo "$disk_info" | awk '{print $5}')
disk_used=$(echo "$disk_info" | awk '{print $3}')
disk_total=$(echo "$disk_info" | awk '{print $2}')
echo "Disk Usage: $disk_percent ($disk_used / $disk_total)"

disk_num=$(echo "$disk_percent" | tr -d '%')  # -d to delete characters 
if [ "$disk_num" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
fi

# --- Memory Usage ---
mem_info=$(top -l 1 -s 0 | grep PhysMem)
memory_used=$(echo "$mem_info" | awk '{print $2}')
memory_unused=$(echo "$mem_info" | awk '{print $8}')
echo "Memory: $memory_used used, $memory_unused free"

# --- CPU Usage ---
cpu_idle=$(top -l 1 -s 0 | grep "CPU usage" | awk '{print $7}') # top -l 1 gives one snapshot and awk grabs column 7
echo "CPU: $cpu_idle idle"

# --- Uptime & Load ---
uptime_info=$(uptime | awk -F'up ' '{print $2}')
echo "Uptime: $uptime_info"
