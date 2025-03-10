#!/usr/bin/env bash

if [ $# -lt 4 ]; then
	echo "Usage: $0 <action> <src> <dst> <network>"
	exit 1
fi

action=$1
source_iface=$2
destination_iface=$3
network=$4

if [ -z $source_iface ]; then echo "Source interface is mandatory"; exit 1; fi
if [ -z $destination_iface ]; then echo "Destination interface is mandatory"; exit 1; fi
if [ -z $network ]; then echo "Network is mandatory"; exit 1; fi

if [ $action = "add" ]; then
	echo "Adding iptables rules"
	iptables -A FORWARD -o $source_iface -i $destination_iface -s $network -m conntrack --ctstate NEW -j ACCEPT
	iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -t nat -F POSTROUTING
	iptables -t nat -A POSTROUTING -o $source_iface -j MASQUERADE

	echo "Enabling forwarding between interfaces"
	# enable forwarding between interfaces
	sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
else
	echo "Disabling forwarding between interfaces"
	# disable forwarding between interfaces
	sudo sh -c "echo 0 > /proc/sys/net/ipv4/ip_forward"

	echo "Removing iptables rules"
	iptables -t nat -D POSTROUTING -o $source_iface -j MASQUERADE
	iptables -D FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -D FORWARD -o $source_iface -i $destination_iface -s $network -m conntrack --ctstate NEW -j ACCEPT

fi

exit 0
