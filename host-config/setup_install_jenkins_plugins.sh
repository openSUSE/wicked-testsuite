#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

echo " * get jenkins cli..."
wget "${jenkins_server}:${jenkins_port}/jnlpJars/jenkins-cli.jar" || exit 1

echo " * install plugins..."
for plugin in "${jenkins_plugins[@]}"; do
    java -jar jenkins-cli.jar -s "${jenkins_server}:${jenkins_port}/" install-plugin "$plugin"
done

exit 0
