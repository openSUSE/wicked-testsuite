#! /bin/bash

# Try to saturate netlink buffers by creating many bridges

[ -z "$1" ] && exit 1
number=$1

for ((i = 0; i < $number; i++)); do
  file=/tmp/tests/ifcfg-br$i
  if [ ! -e $file ]; then
    echo "BOOTPROTO=none"                >  $file
    echo "BRIDGE=yes"                    >> $file
    echo "BRIDGE_FORWARDDELAY=0"         >> $file
    echo "BRIDGE_PORTS="                 >> $file
    echo "BRIDGE_STP=off"                >> $file
    echo "BROADCAST="                    >> $file
    #echo "IPADDR=192.168.3.$i"          >> $file
    echo "DHCLIENT_SET_DEFAULT_ROUTE=no" >> $file
    echo "CHECK_DUPLICATE_IP=no"         >> $file
    #echo "ETHTOOL_OPTIONS=''"           >> $file
    #echo "MTU=''"                       >> $file
    #echo "NETMASK=''"                   >> $file
    #echo "NETWORK=''"                   >> $file
    #echo "REMOTE_IPADDR=''"             >> $file
    echo "STARTMODE=auto"                >> $file
  fi
done

wic.sh ifup --ifconfig compat:/tmp/tests all

journalctl -u wickedd-dhcp4 > /tmp/tests/wickedd-dhcp4.log

for ((i = 0; i < $number; i++)); do
  file=/tmp/tests/ifcfg-br$i
  wic.sh ifdown br$i
  rm $file
done

if grep -q "No buffer space" /tmp/tests/wickedd-dhcp4.log; then
  echo "No buffer space" >&2
  exit 2
fi
