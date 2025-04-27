#!/bin/bash

while true; do
	eth_up=$(ip -br a | grep UP | grep -E 'eth0|wlp0s20f3|wlo1' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}($|/(16|24))\b")

	for ip in $eth_up; do
		hosts+=("$(nmap -sV $ip -p22 | grep "Nmap scan")")
	done

	clear

	echo "======== IPs ========"
	echo ${hosts[@]} | grep -oE  "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"

	unset hosts[@] 

	sleep 1
done
