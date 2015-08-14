#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

echo " * customize jenkins user..."
chsh --shell /bin/bash jenkins
usermod -a -G qemu,libvirt jenkins

# FIXME: ebischoffs way via polkit isn't working ATM
# take libvirtd.conf for now
echo "auth_unix_ro = \"none\"" >> /etc/libvirt/libvirtd.conf
echo "auth_unix_rw = \"none\"" >> /etc/libvirt/libvirtd.conf
systemctl restart libvirtd
# allow libvirt group members accessing libvirtd
#cp ./files-host/10-virt.rules /etc/polkit-1/rules.d/10-virt.rules
#systemctl restart polkit

echo """
jenkins   ALL = NOPASSWD: /usr/bin/build
""" >> /etc/sudoers

if test -f "${jenkins_home}/.oscrc" ; then
    echo "WARNING: file '.oscrc' exists. Skip."
else
    cp ./files-host/.oscrc "${jenkins_home}"
    chown jenkins:jenkins "${jenkins_home}/.oscrc"
    echo "osc username: "
    read username
    echo "osc password: "
    read -s password
    su -c "osc config https://api.suse.de user $username > /dev/null" jenkins
    su -c "osc config https://api.opensuse.org user $username > /dev/null" jenkins
    su -c "osc config https://api.suse.de pass $password > /dev/null" jenkins
    su -c "osc config https://api.opensuse.org pass $password > /dev/null" jenkins
fi


mkdir "${jenkins_home}/builds"
chown jenkins:jenkins "${jenkins_home}/builds"

exit 0
