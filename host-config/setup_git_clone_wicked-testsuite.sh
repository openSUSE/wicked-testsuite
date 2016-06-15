#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# git clone opensuse/wicked-testsuite
#-----------------------------------------------------------------------------
echo " * clone git repo from '${git_repository}'..."
if [ ! -d "${jenkins_home}/cucumber" ]; then
    git clone "${git_branch:+-b $git_branch}" "$git_repository" ${jenkins_home}/cucumber
    chown -R jenkins:jenkins ${jenkins_home}/cucumber

    ln -s "${jenkins_home}/cucumber/jenkins-files/build-and-test-wicked.sh"\
        "${jenkins_home}/build-and-test-wicked.sh"
    chown -h jenkins:jenkins "${jenkins_home}/build-and-test-wicked.sh"
else
    if [ -d "${jenkins_home}/cucumber/.git" ]; then
        cd "${jenkins_home}/cucumber/.git"
        # http://stackoverflow.com/questions/3258243/git-check-if-pull-needed
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})
        BASE=$(git merge-base @ @{u})

        if [ $LOCAL = $REMOTE ]; then
            echo "INFO: repository is Up-to-date"
        elif [ $LOCAL = $BASE ]; then
            echo "WARNING: need to pull"
        elif [ $REMOTE = $BASE ]; then
            echo "WARNING: need to push"
        else
            echo "WARNING: diverged"
        fi
    fi
fi

exit 0
