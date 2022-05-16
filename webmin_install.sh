#!/bin/bash

# shell script to install webmin in ubuntu 20.04
# Webmin is a web-based interface for system administration for linux. Webmin allows the user to configure operating system internals, such as users, disk quotas, services or configuration files, as well as modify and control open-source apps, such as the Apache HTTP Server, PHP or MySQL. 

# update system
update_system()
{
    sudo apt update -y
}

# add the Webmin repository
#sudo echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
sudo echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee /etc/apt/sources.list.d/webin.list

# download the Webmin PGP key and add it to your system’s list of keys
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add

# update system 
update_system

# install Webmin
sudo apt install webmin -y

echo "webmin installation completed"


# notes
# --> You can now login to https://ipaddress:10000/
# as root with your root password, or as any user who can use sudo
# to run commands as root.
