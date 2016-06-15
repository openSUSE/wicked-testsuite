#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

bridge="wickedbr0"
dummy="dummy0"
dummy_out="wickedout0"
git_repository="https://github.com/openSUSE/wicked-testsuite.git"
git_branch=""

jenkins_home="/var/lib/jenkins"
jenkins_server="http://localhost"
jenkins_port="8080"
jenkins_wait=60

twopence_dir="/var/run/twopence"

declare -a jenkins_plugins=(\
    "http://updates.jenkins-ci.org/download/plugins/cucumber/0.0.2/cucumber.hpi"
    "http://updates.jenkins-ci.org/download/plugins/cucumber-testresult-plugin/0.7/cucumber-testresult-plugin.hpi"
    "http://updates.jenkins-ci.org/download/plugins/cucumber-perf/2.0.6/cucumber-perf.hpi"
    "http://updates.jenkins-ci.org/download/plugins/cucumber-reports/0.1.0/cucumber-reports.hpi"
    "http://updates.jenkins-ci.org/download/plugins/git/2.3.5/git.hpi"
    "http://updates.jenkins-ci.org/download/plugins/git-client/1.17.1/git-client.hpi"
    "http://updates.jenkins-ci.org/download/plugins/ruby-runtime/0.12/ruby-runtime.hpi"
    "http://updates.jenkins-ci.org/download/plugins/urltrigger/0.37/urltrigger.hpi"
    "http://updates.jenkins-ci.org/download/plugins/skip-certificate-check/1.0/skip-certificate-check.hpi"
    "http://updates.jenkins-ci.org/download/plugins/scm-api/0.2/scm-api.hpi"
    "http://updates.jenkins-ci.org/download/plugins/parameterized-trigger/2.26/parameterized-trigger.hpi"
    )
