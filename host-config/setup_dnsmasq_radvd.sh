#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# dnsmasq
#-----------------------------------------------------------------------------
echo " * configure dnsmasq..."

found="n"
for i in /etc/dnsmasq.conf /etc/dnsmasq.d/*.conf ; do
    grep -qs "^interface=wickedbr0" $i && found="y";
done

if [ "$found" = "n" ]; then
    test -d /etc/dnsmasq.d || mkdir /etc/dnsmasq.d
    cp -b ./files-host/dnsmasq.conf /etc/dnsmasq.d/wicked-testsuite.conf
    if ! grep -qs "^conf-dir=/etc/dnsmasq.d" /etc/dnsmasq.conf; then
        echo "conf-dir=/etc/dnsmasq.d" >> /etc/dnsmasq.conf
    fi
fi

systemctl -q is-enabled dnsmasq || systemctl enable dnsmasq
systemctl -q is-active dnsmasq || systemctl start dnsmasq

#-----------------------------------------------------------------------------
# radvd
#-----------------------------------------------------------------------------
echo " * configure radvd..."

if ! grep -qs "^interface[ \t]*wickedbr" /etc/radvd.conf ; then
    cp -b /etc/radvd.conf /etc/radvd.conf.backup
    cp ./files-host/radvd.conf /etc/radvd.conf
fi

systemctl -q is-enabled radvd || systemctl enable radvd
systemctl -q is-active radvd || systemctl start radvd

exit 0
