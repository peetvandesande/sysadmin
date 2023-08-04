#!/usr/bin/bash
#
# blackhole.sh
# Adds blackhole routes for CIDRs listed in text files
#
if [ ! -f "${1}" ]; then
	# File doesn't exist
	echo "Error: file doesn't exist: ${1}"
	exit 1
fi

if [ ! -r "${1}" ]; then
	# File doesn't exist
	echo "Error: file isn't readable: ${1}"
	exit 2
fi

counter=0
total=`wc -l ${1} | cut -d' ' -f1`
kREGEX_CIDR='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}'

while read line; do
	if [[ ${line} =~ $kREGEX_CIDR ]]; then
		let counter++
		ip route add blackhole ${line}
	fi
done < "${1}"

echo "Blackholed ${counter} routes from ${1}"
