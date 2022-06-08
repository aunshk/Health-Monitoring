#!/bin/bash
# shell script for application health monitoring

#applciation details
app_name=nginx-demo
service_name=nginx
service_port=80
app_url=#application Url



#check URL
curl -sk "$app_url" --connect-timeout 15 > /dev/null 2>&1
url_status=$(echo $?)
if [[ $url_status != 0 ]]
then 
    echo "ALERT: $app_name URL is not accessible"
fi 
echo ""

#check port accessible or not
sudo ss -tulpn | grep $service_port > /dev/null 2>&1
port_status=$(echo $?)
if [[ $url_status != 0 ]]
then 
    echo "ALERT: $app_name Port is not accessible"
fi 
echo ""

# check service status
sudo service $service_name status > /dev/null 2>&1
valid_status=$(echo $?)
sudo service $service_name status | grep -w active > /dev/null 2>&1 
service_status=$(echo $?) 
# check if service is valid or not
if [[ $valid_status = 4 ]]
then 
    echo "ALERT: Invalid service name $service_name"
elif [[ $service_status = 3 ]]
then
    echo "ALERT: service $service_name is stopped, please restart the $service_name service"
fi
echo ""

#check process cpu usage
echo "Process CPU usage"
ps -eo command,%cpu | grep $service_name | grep -Ev grep
echo ""

#check process ram usage
echo "Process RAM usage"
ps -eo command,%mem | grep $service_name | grep -Ev grep
echo ""

#check system load
echo "Load Average: $(cat /proc/loadavg | awk '{print $1,$2,$3}')"
echo ""

