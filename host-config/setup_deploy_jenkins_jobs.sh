#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# copy jobs
#-----------------------------------------------------------------------------
echo " * deploy jenkins jobs..."
su -c "cd ${jenkins_home}/cucumber/jenkins-files; sh ./config-job.sh" jenkins

echo " * restart jenkins..."
systemctl restart jenkins

exit 0
