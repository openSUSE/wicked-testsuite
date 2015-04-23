#! /bin/bash

set -e


echo
echo "### Setup the reference server ###"
ref="virtio:/var/run/twopence/ref-wicked-master.sock"

twopence_command $ref "mkdir -p /etc/sysconfig/network/pool"

IFS=$'\r\n' paths=($(cat paths-ref.txt))
for ((i=0; i<${#paths[@]}; i++)); do
  IFS=" " fields=(${paths[i]})
  src=${fields[0]}
  dst=${fields[1]}
  twopence_inject $ref $src $dst
done

twopence_command $ref "chmod ug+x /etc/init.d/iptables"
twopence_command $ref "chmod o+r /etc/dhcpd-*.conf"
twopence_command $ref "chmod o+r /etc/dhcpd6-*.conf"
twopence_command $ref "chmod o+r /etc/radvd-*.conf"
twopence_command $ref "chmod o+r /etc/openvpn/server-tun.conf"
twopence_command $ref "chmod o+r /etc/openvpn/server-tap.conf"
twopence_command $ref "chmod ugo+rx /usr/local/bin/*.sh"

twopence_command $ref "sed -i 's/^DHCLIENT_BIN=.*$/DHCLIENT_BIN=\"dhclient\"/' /etc/sysconfig/network/dhcp"

twopence_command $ref "SuSEfirewall2 off"
twopence_command $ref "insserv iptables"

twopence_command $ref "ln -sf /etc/dhcpd-default.conf /etc/dhcpd.conf"
twopence_command $ref "systemctl enable dhcpd"

twopence_command $ref "ln -sf /etc/dhcpd6-default.conf /etc/dhcpd6.conf"
twopence_command $ref "systemctl enable dhcpd6"

twopence_command $ref "ln -sf /etc/radvd-default.conf /etc/radvd.conf"
twopence_command $ref "systemctl enable radvd"

twopence_command $ref "ln -sf /etc/openvpn/server-tun.conf /etc/openvpn/server.conf"

echo
echo "### Please reboot the machine ###"
echo "It is needed to activate the new configuration."
