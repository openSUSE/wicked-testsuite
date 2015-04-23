#! /bin/bash

set -e


echo
echo "### Setup the reference server ###"
ref="virtio:/var/run/twopence/ref-wicked-master.sock"

echo "Configure the DHCP client"
twopence_command $ref "sed -i 's/^DHCLIENT_BIN=.*$/DHCLIENT_BIN=\"dhclient\"/' /etc/sysconfig/network/dhcp"

echo "Configure the firewall"
twopence_command $ref "SuSEfirewall2 off"
twopence_inject $ref "files-ref/iptables" "/etc/init.d/iptables"
twopence_command $ref "chmod ug+x /etc/init.d/iptables"
twopence_command $ref "insserv iptables"
twopence_inject $ref "files-ref/ip4tablesrc" "/etc/ip4tablesrc"
twopence_inject $ref "files-ref/ip6tablesrc" "/etc/ip6tablesrc"

echo "Configure the addresses and routes"
twopence_inject $ref "files-ref/ifcfg-eth0" "/etc/sysconfig/network/ifcfg-eth0"
twopence_inject $ref "files-ref/ifcfg-eth1" "/etc/sysconfig/network/ifcfg-eth1"
twopence_inject $ref "files-ref/ifcfg-eth2" "/etc/sysconfig/network/ifcfg-eth2"
twopence_inject $ref "files-ref/ifroute-eth1" "/etc/sysconfig/network/ifroute-eth1"
twopence_command $ref "mkdir -p /etc/sysconfig/network/pool"
twopence_inject $ref "files-ref/ifcfg-bond0" "/etc/sysconfig/network/pool/ifcfg-bond0"
twopence_inject $ref "files-ref/ifcfg-bond1" "/etc/sysconfig/network/pool/ifcfg-bond1"
twopence_inject $ref "files-ref/ifcfg-eth0.42" "/etc/sysconfig/network/pool/ifcfg-eth0.42"
twopence_inject $ref "files-ref/ifcfg-eth1.42" "/etc/sysconfig/network/pool/ifcfg-eth1.42"
twopence_inject $ref "files-ref/ifcfg-eth0.1" "/etc/sysconfig/network/pool/ifcfg-eth0.1"
twopence_inject $ref "files-ref/ifcfg-eth1.1" "/etc/sysconfig/network/pool/ifcfg-eth1.1"
twopence_inject $ref "files-ref/ifcfg-bond0.42" "/etc/sysconfig/network/pool/ifcfg-bond0.42"
twopence_inject $ref "files-ref/ifcfg-bond0.73" "/etc/sysconfig/network/pool/ifcfg-bond0.73"
twopence_inject $ref "files-ref/ifcfg-tun1" "/etc/sysconfig/network/pool/ifcfg-tun1"
twopence_inject $ref "files-ref/ifcfg-tap1" "/etc/sysconfig/network/pool/ifcfg-tap1"
twopence_inject $ref "files-ref/ifcfg-gre1" "/etc/sysconfig/network/pool/ifcfg-gre1"
twopence_inject $ref "files-ref/ifcfg-tunl1" "/etc/sysconfig/network/pool/ifcfg-tunl1"
twopence_inject $ref "files-ref/ifcfg-sit1" "/etc/sysconfig/network/pool/ifcfg-sit1"
twopence_inject $ref "files-ref/ifcfg-ib0-ud-nomux" "/etc/sysconfig/network/pool/ifcfg-ib0-ud-nomux"
twopence_inject $ref "files-ref/ifcfg-ib0-cm-nomux" "/etc/sysconfig/network/pool/ifcfg-ib0-cm-nomux"
twopence_inject $ref "files-ref/ifcfg-ib0-ud-mux" "/etc/sysconfig/network/pool/ifcfg-ib0-ud-mux"
twopence_inject $ref "files-ref/ifcfg-ib0-cm-mux" "/etc/sysconfig/network/pool/ifcfg-ib0-cm-mux"
twopence_inject $ref "files-ref/ifcfg-ib0.8001" "/etc/sysconfig/network/pool/ifcfg-ib0.8001"

echo "Configure and enable the DHCP server"
twopence_inject $ref "files-ref/dhcpd" "/etc/sysconfig/dhcpd"
twopence_inject $ref "files-ref/dhcpd-default.conf" "/etc/dhcpd-default.conf"
twopence_inject $ref "files-ref/dhcpd-route.conf" "/etc/dhcpd-route.conf"
twopence_inject $ref "files-ref/dhcpd-mtu.conf" "/etc/dhcpd-mtu.conf"
twopence_inject $ref "files-ref/dhcpd-infiniband.conf" "/etc/dhcpd-infiniband.conf"
twopence_command $ref "chmod ugo+r /etc/dhcpd-*.conf"
twopence_command $ref "ln -sf /etc/dhcpd-default.conf /etc/dhcpd.conf"
twopence_command $ref "systemctl enable dhcpd"

echo "Configure and enable the DHCPv6 server"
twopence_inject $ref "files-ref/dhcpd6-default.conf" "/etc/dhcpd6-default.conf"
twopence_inject $ref "files-ref/dhcpd6-infiniband.conf" "/etc/dhcpd6-infiniband.conf"
twopence_command $ref "chmod ugo+r /etc/dhcpd6-*.conf"
twopence_command $ref "ln -sf /etc/dhcpd6-default.conf /etc/dhcpd6.conf"
twopence_command $ref "systemctl enable dhcpd6"

echo "Configure and enable the RADVD server"
twopence_inject $ref "files-ref/radvd-default.conf" "/etc/radvd-default.conf"
for ((i = 1; i <= 12; i++)); do
  twopence_inject $ref "files-ref/radvd-${i}.conf" "/etc/radvd-${i}.conf"
done
twopence_inject $ref "files-ref/radvd-infiniband.conf" "/etc/radvd-infiniband.conf"
twopence_command $ref "chmod o+r /etc/radvd-*.conf"
twopence_command $ref "ln -sf /etc/radvd-default.conf /etc/radvd.conf"
twopence_command $ref "systemctl enable radvd"

echo "Configure the openvpn server"
twopence_inject $ref "files-ref/openvpn-tun.conf" "/etc/openvpn/server-tun.conf"
twopence_command $ref "chmod o+r /etc/openvpn/server-tun.conf"
twopence_inject $ref "files-ref/openvpn-tap.conf" "/etc/openvpn/server-tap.conf"
twopence_command $ref "chmod o+r /etc/openvpn/server-tap.conf"
twopence_command $ref "ln -sf /etc/openvpn/server-tun.conf /etc/openvpn/server.conf"

echo "Enable packet forwarding"
twopence_inject $ref "files-ref/sysctl.conf" "/etc/sysctl.conf"

echo "Install server-side  utilities"
twopence_inject $ref "files-ref/cleanup.sh" "/usr/local/bin/cleanup.sh"
twopence_inject $ref "files-ref/tcpdump.sh" "/usr/local/bin/tcpdump.sh"
twopence_command $ref "chmod ugo+rx /usr/local/bin/*.sh"

echo
echo "### Please reboot the machine ###"
echo "It is needed to activate the new configuration."
