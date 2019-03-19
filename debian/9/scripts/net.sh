#!/bin/bash -eux

#sudo apt-get install -y ifupdown

#sudo cat > /etc/network/interfaces << EOF
#iface lo inet loopback
#auto lo

#auto eth0
#iface eth0 inet dhcp
#EOF

#sudo systemctl stop networkd-dispatcher
#sudo systemctl disable networkd-dispatcher
#sudo systemctl mask networkd-dispatcher
#sudo apt-get purge -y nplan netplan.io
#sudo rm -rf /etc/netplan

sudo apt-get install -y open-vm-tools

# Fixes for open-vm-tools
sudo sed -i '11 s/^/#/' /usr/lib/tmpfiles.d/tmp.conf
sudo sed -i '7i After=dbus.service' /lib/systemd/system/open-vm-tools.service
