#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# dnsmasq and radvd
#-----------------------------------------------------------------------------
echo " * configure dnsmasq..."
if test -f "/etc/dnsmasq.conf" ; then
    echo "WARNING: file '/etc/dnsmasq.conf' exists. Skip."
else
    cp ./files-host/dnsmasq.conf /etc
    systemctl -q is-enabled dnsmasq || systemctl enable dnsmasq
    systemctl -q is-active dnsmasq || systemctl start dnsmasq
fi

echo " * configure radvd..."
if test -f "/etc/radvd.conf" ; then
    echo "WARNING: file '/etc/radvd.conf' exists. Skip."
else
    cp ./files-host/radvd.conf /etc
    systemctl -q is-enabled radvd || systemctl enable radvd
    systemctl -q is-active radvd || systemctl start radvd
fi

exit 0
