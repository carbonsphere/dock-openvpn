#!/bin/sh

echo -e "Checking for server configurations.\n"

if [ ! -e "$PWD/server.conf" ]; then
	echo "Error: no server.conf found. exiting...."
	exit
fi

mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

TLSKEYNAME="ta.key"

if [ ! -e "$PWD/$TLSKEYNAME" ]; then
	echo "Generating secret keys....."
	openvpn --genkey --secret $PWD/$TLSKEYNAME
	echo "Finished.\nBesure to copy $TLSKEYNAME into your client file"
fi

service openvpn start

touch /var/log/messages
tailf /var/log/messages
