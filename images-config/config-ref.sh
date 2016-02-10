#! /bin/bash

mkdir -p /etc/sysconfig/network/pool

cp ./files-ref/iptables                /etc/init.d/iptables
cp ./files-ref/ip4tablesrc             /etc/ip4tablesrc
cp ./files-ref/ip6tablesrc             /etc/ip6tablesrc
cp ./files-ref/ifcfg-eth0              /etc/sysconfig/network/ifcfg-eth0
cp ./files-ref/ifcfg-eth1              /etc/sysconfig/network/ifcfg-eth1
cp ./files-ref/ifcfg-eth2              /etc/sysconfig/network/ifcfg-eth2
cp ./files-ref/ifroute-eth1            /etc/sysconfig/network/ifroute-eth1
cp ./files-ref/ifcfg-bond0-rr          /etc/sysconfig/network/pool/ifcfg-bond0-rr
cp ./files-ref/ifcfg-bond0-ab          /etc/sysconfig/network/pool/ifcfg-bond0-ab
cp ./files-ref/ifcfg-bond0-xor         /etc/sysconfig/network/pool/ifcfg-bond0-xor
cp ./files-ref/ifcfg-bond0-bc          /etc/sysconfig/network/pool/ifcfg-bond0-bc
cp ./files-ref/ifcfg-bond0-ieee        /etc/sysconfig/network/pool/ifcfg-bond0-ieee
cp ./files-ref/ifcfg-bond0-ab-arping   /etc/sysconfig/network/pool/ifcfg-bond0-ab-arping
cp ./files-ref/ifcfg-bond0-ab-arping-2ips   /etc/sysconfig/network/pool/ifcfg-bond0-ab-arping-2ips
#cp ./files-ref/ifcfg-bond0-rr-0        /etc/sysconfig/network/pool/ifcfg-bond0-rr-0 # bonding.c: Bonding without monitoring is nonsense/unsupported
#cp ./files-ref/ifcfg-bond0-ab-arping-0 /etc/sysconfig/network/pool/ifcfg-bond0-ab-arping-0 # bonding.c: Bonding without monitoring is nonsense/unsupported
cp ./files-ref/ifcfg-br0               /etc/sysconfig/network/pool/ifcfg-br0
cp ./files-ref/ifcfg-bond1             /etc/sysconfig/network/pool/ifcfg-bond1
cp ./files-ref/ifcfg-eth0.42           /etc/sysconfig/network/pool/ifcfg-eth0.42
cp ./files-ref/ifcfg-eth1.42           /etc/sysconfig/network/pool/ifcfg-eth1.42
cp ./files-ref/ifcfg-eth0.1            /etc/sysconfig/network/pool/ifcfg-eth0.1
cp ./files-ref/ifcfg-eth1.1            /etc/sysconfig/network/pool/ifcfg-eth1.1
cp ./files-ref/ifcfg-bond0.42          /etc/sysconfig/network/pool/ifcfg-bond0.42
cp ./files-ref/ifcfg-bond0.73          /etc/sysconfig/network/pool/ifcfg-bond0.73
cp ./files-ref/ifcfg-tun1              /etc/sysconfig/network/pool/ifcfg-tun1
cp ./files-ref/ifcfg-tap1              /etc/sysconfig/network/pool/ifcfg-tap1
cp ./files-ref/ifcfg-gre1              /etc/sysconfig/network/pool/ifcfg-gre1
cp ./files-ref/ifcfg-tunl1             /etc/sysconfig/network/pool/ifcfg-tunl1
cp ./files-ref/ifcfg-sit1              /etc/sysconfig/network/pool/ifcfg-sit1
cp ./files-ref/ifcfg-ib0-ud-nomux      /etc/sysconfig/network/pool/ifcfg-ib0-ud-nomux
cp ./files-ref/ifcfg-ib0-cm-nomux      /etc/sysconfig/network/pool/ifcfg-ib0-cm-nomux
cp ./files-ref/ifcfg-ib0-ud-mux        /etc/sysconfig/network/pool/ifcfg-ib0-ud-mux
cp ./files-ref/ifcfg-ib0-cm-mux        /etc/sysconfig/network/pool/ifcfg-ib0-cm-mux
cp ./files-ref/ifcfg-ib0.8001          /etc/sysconfig/network/pool/ifcfg-ib0.8001
cp ./files-ref/dhcpd                   /etc/sysconfig/dhcpd
cp ./files-ref/dhcpd-default.conf      /etc/dhcpd-default.conf
cp ./files-ref/dhcpd-route.conf        /etc/dhcpd-route.conf
cp ./files-ref/dhcpd-mtu.conf          /etc/dhcpd-mtu.conf
cp ./files-ref/dhcpd-infiniband.conf   /etc/dhcpd-infiniband.conf
cp ./files-ref/dhcpd6-default.conf     /etc/dhcpd6-default.conf
cp ./files-ref/dhcpd6-infiniband.conf  /etc/dhcpd6-infiniband.conf
cp ./files-ref/radvd-default.conf      /etc/radvd-default.conf
cp ./files-ref/radvd-1.conf            /etc/radvd-1.conf
cp ./files-ref/radvd-2.conf            /etc/radvd-2.conf
cp ./files-ref/radvd-3.conf            /etc/radvd-3.conf
cp ./files-ref/radvd-4.conf            /etc/radvd-4.conf
cp ./files-ref/radvd-5.conf            /etc/radvd-5.conf
cp ./files-ref/radvd-6.conf            /etc/radvd-6.conf
cp ./files-ref/radvd-7.conf            /etc/radvd-7.conf
cp ./files-ref/radvd-8.conf            /etc/radvd-8.conf
cp ./files-ref/radvd-9.conf            /etc/radvd-9.conf
cp ./files-ref/radvd-10.conf           /etc/radvd-10.conf
cp ./files-ref/radvd-11.conf           /etc/radvd-11.conf
cp ./files-ref/radvd-12.conf           /etc/radvd-12.conf
cp ./files-ref/radvd-infiniband.conf   /etc/radvd-infiniband.conf
cp ./files-ref/openvpn-tun.conf        /etc/openvpn/server-tun.conf
cp ./files-ref/openvpn-tap.conf        /etc/openvpn/server-tap.conf
cp ./files-ref/sysctl.conf             /etc/sysctl.conf
cp ./files-ref/cleanup.sh              /usr/local/bin/cleanup.sh
cp ./files-ref/tcpdump.sh              /usr/local/bin/tcpdump.sh

chmod ug+x /etc/init.d/iptables
chmod o+r /etc/dhcpd-*.conf
chmod o+r /etc/dhcpd6-*.conf
chmod o+r /etc/radvd-*.conf
chmod o+r /etc/openvpn/server-tun.conf
chmod o+r /etc/openvpn/server-tap.conf
chmod ugo+rx /usr/local/bin/*.sh

sed -i 's/^DHCLIENT_BIN=.*$/DHCLIENT_BIN=\"dhclient\"/' /etc/sysconfig/network/dhcp

SuSEfirewall2 off || true
insserv iptables

ln -sf /etc/dhcpd-default.conf /etc/dhcpd.conf
systemctl enable dhcpd

ln -sf /etc/dhcpd6-default.conf /etc/dhcpd6.conf
systemctl enable dhcpd6

ln -sf /etc/radvd-default.conf /etc/radvd.conf
systemctl enable radvd

ln -sf /etc/openvpn/server-tun.conf /etc/openvpn/server.conf
