#!/usr/bin/env bash

source_iface="wlp0s20f3"
destination_iface_lan="eth0"
network="10.10.60.50/24"

echo "Set eth0 to LAN"
sudo ip link set enx00e04c680c91 down
sudo ip link set enx00e04c680c91 name $destination_iface_lan
sudo ip link set $destination_iface_lan up
sudo ip addr add $network dev $destination_iface_lan

echo "Reload Local DHCP Server"
sudo service isc-dhcp-server stop
sudo service isc-dhcp-server start

exit 0
