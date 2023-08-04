#!/usr/bin/bash
#
# ufw-unblock.sh
# Deletes UFW rules to block CIDRs listed in text files
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

# Time script as it may take a long time
SECONDS=0
counter=0
total=`wc -l ${1} | cut -d' ' -f1`
kREGEX_CIDR='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}'

echo "Processing ${total} lines from ${1} to block traffic..."
while read line; do
	if [[ ${line} =~ $kREGEX_CIDR ]]; then
		let counter++
		ufw delete deny from ${line} 2>&1 1>/dev/null
		ufw delete deny to ${line} 2>&1 1>/dev/null
	fi
done < "${1}"

echo "Unblocked traffic to and from ${counter} destinations in ${1} during ${SECONDS} seconds"
