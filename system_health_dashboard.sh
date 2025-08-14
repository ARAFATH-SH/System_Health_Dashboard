#!/bin/bash

Refresh_time=20
LOG_FILE="system_stats.csv"

cpu_usage(){
	echo "CPU Usage: "
	mpstat -P ALL 1 1 | awk '/Average/ && $2 ~ /[0-9]/ {printf "Core %s: %.1f%%\n", $2, 100 - $12}'
} 

memory_usage() {
    echo -e "\n Memory Usage:"
    free -h 
}

disk_usage() {
    echo -e "\n Disk Usage:"
    df -h --output=source,size,used,avail -x tmpfs -x devtmpfs
}

top_processes() {
    echo -e "\n Top 5 CPU-consuming processes:"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

    echo -e "\n Top 5 Memory-consuming processes:"
    ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
}

network_stats() {
    echo -e "\n Network Stats:"
    ip a | awk '/inet / && $2 !~ /127.0.0.1/ {print "IP Address:", $2}'
    echo "Data Sent/Received:"
    cat /proc/net/dev | awk 'NR>2 {rx+=$2; tx+=$10} END {printf("Received: %.2f MB, Sent: %.2f MB\n", rx/1024/1024, tx/1024/1024)}'
}

user_activity() {
    echo -e "\n Logged-in Users:"
    who
}

draw_bar() {
    local label=$1
    local value=$2
    local max=100
    local bar_width=50
    local filled=$((value * bar_width / max))
    local empty=$((bar_width - filled))

    printf "\n %-10s [\e[42m%*s\e[0m%*s] %3d%%\n" \
        "$label" "$filled" "" "$empty" "" "$value"
}

cpu_graph() {
    cpu=$(mpstat 1 1 | awk '/Average:/ && $3 ~ /[0-9]/ {printf("%.0f", 100 - $12)}')
    draw_bar "CPU" "$cpu"
}

memory_graph() {
    mem_used=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')
    draw_bar "Memory" "$mem_used"
}

disk_graph() {
    disk_used=$(df / | awk 'END {gsub("%", "", $5); print $5}')
    draw_bar "Disk" "$disk_used"
}

log_stats() {
    {	
	echo " $(date) "
        cpu_usage
        memory_usage
        disk_usage
        top_processes
        network_stats
        user_activity
        echo ""
    } >> "$LOG_FILE"
}


while true;
	do
	clear
	echo "System Health Dashboard - $(date)"
	
	cpu_usage
	memory_usage
	disk_usage
	top_processes
	network_stats
	user_activity	
	cpu_graph
	memory_graph
	disk_graph

	log_stats
	echo -e "\n Updating in $Refresh_time seconds."
	sleep "$Refresh_time"
done

