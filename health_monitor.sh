#!/bin/bash
# Server health monitoring shell script

# Health monitoring thresholds 
ram_threshold=300
cpu_threshold=1
disk_threshold=80

# check internet is connected or not
ping -c 1 google.comm &> /dev/null && echo "Internet: Connected" || echo "Internet: Disconnected"

#OS name
echo "OS $(cat /etc/os-release | grep -w NAME)"
echo ""

#OS version
echo "OS $(cat /etc/os-release | grep -w VERSION)"
echo ""

#OS architecture
echo "OS Architecture: $(uname -m)"
echo ""

#Kernel Release
echo "Kernel release: $(uname -r)"
echo ""

#Hostname
echo "Hostname: $(hostname)"
echo ""

#internal ip address
echo "Internal IP address: $(hostname -I)"
echo ""

#External ip address
echo "External IP address: $(curl -s ipecho.net/plain;echo)"
echo ""

#DNS info
echo "Name servers:" 
cat /etc/resolv.conf | sed '1 d' | awk '{print $2}'
echo ""

#Logged in users
echo "Logged in Users:"
who
echo ""

#RAM Usage
echo "RAM Usage:"
free -m | head -n 2
echo ""
ram_use=$(free -m | grep Mem | awk '{print $3}')
if [[ $ram_use > $ram_threshold ]]
then
    echo "WARNING: RAM usage is above the threshold"
fi
echo ""

#SWAP memory info
echo "Swap Memory:"
free -m | sed '2d'
echo ""

#Disk usage
echo "Disk Usage:"
df -h| grep 'Filesystem\|/dev/mapper*'
disk_use=$(df -h | grep '/dev/mapper*' | awk '{print $5}' | cut -d '%' -f 1)
if [[ $disk_use > $disk_threshold ]]
then
    echo "WARNING: Disk usage is above the $disk_threshold%"
fi
echo ""

#Load Average
echo "Load Average: $(cat /proc/loadavg | awk '{print $1,$2,$3}')"
echo ""
cpu_load=$(cat /proc/loadavg | awk '{print $2}' | cut -d '.' -f 1)
if [[ $cpu_load > $cpu_threshold ]]
then 
   echo "WARNING: CPU load is above the threshold"
fi
echo ""

#server uptime
echo "Server Uptime: $(uptime -s)"
echo ""

# Top 5 CPU consuming processes
echo "Top 5 CPU consuming processes" 
ps -eo pid,user,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo ""

#Top 5 RAM conduming processes
echo "Top 5 RAM conduming processes"
ps -eo pid,user,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo ""





