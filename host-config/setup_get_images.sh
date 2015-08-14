#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# get images from internal build service
#-----------------------------------------------------------------------------
echo " * get sut/ref images..."
mkdir -p "${jenkins_home}/images"
${jenkins_home}/cucumber/jenkins-files/get-images.sh -d "${jenkins_home}/images"
chown -R jenkins:jenkins ${jenkins_home}/images

exit 0
