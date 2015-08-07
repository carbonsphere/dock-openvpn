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

echo -e "Parsing tun interface ip\n"
VPNNET=`ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | tail -1`
VPNIP=$VPNNET/24

echo -e "Adding $VPNIP nat rules\n"
iptables -t nat -A POSTROUTING -s $VPNIP -o eth0 -j MASQUERADE

TLSKEYNAME="ta.key"

if [ ! -e "$PWD/$TLSKEYNAME" ]; then
	echo "Generating secret keys....."
	openvpn --genkey --secret $PWD/$TLSKEYNAME
	echo "Finished.\nBesure to copy $TLSKEYNAME into your client file"
fi

service openvpn start

touch /var/log/messages
tailf /var/log/messages
