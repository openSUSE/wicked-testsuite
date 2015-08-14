#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# Jenkins setup
#-----------------------------------------------------------------------------
echo " * start jenkins server..."
systemctl -q is-enabled jenkins || systemctl enable jenkins
systemctl -q is-active jenkins || systemctl start jenkins

echo " * wait for jenkins http server (${jenkins_wait}s)..."
sleep ${jenkins_wait}

exit 0
