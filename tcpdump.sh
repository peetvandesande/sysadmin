#!/bin/bash
#
# tcpdump.sh
# Runs tcpdump on containers' veth interfaces

CONTAINERS="unbound nginx phpfpm sogo"

for container in $CONTAINERS; do
	echo $container
	containerid=`docker container ps | grep ${container} | cut -f 1 -d " "`
	echo "Container ID = '${containerid}'"
	linkid=`docker exec -ti ${containerid} cat /sys/class/net/eth0/iflink | tr -d '\r'`
	echo "Link ID = '${linkid}'"
	vethid=`ip link | grep ${linkid} | cut -d ":" -f 2 | cut -d "@" -f 1 | xargs`
	echo "Veth ID = '${vethid}'"
	tcpdump -i ${vethid} -w /tmp/${container}-${vethid}.pcap -nq &
	echo "tcpdump PID = ${!}"
done
