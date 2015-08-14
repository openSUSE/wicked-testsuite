#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

sh ./setup_jenkins_user.sh || exit 1
sh ./setup_network.sh || exit 1
sh ./setup_dnsmasq_radvd.sh || exit 1
sh ./setup_git_clone_wicked-testsuite.sh || exit 1
sh ./setup_get_images.sh || exit 1
sh ./setup_twopence_directory.sh || exit 1
sh ./setup_start_jenkins.sh || exit 1
sh ./setup_install_jenkins_plugins.sh || exit 1
sh ./setup_deploy_jenkins_jobs.sh || exit 1

exit 0
