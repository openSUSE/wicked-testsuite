#! /bin/bash

ID=0
SUBDIR="cucumber"
GIT_REPO="openSUSE"
JOBS_DIR=/var/lib/jenkins/jobs
# do not auto-enable all jobs;
# better to auto-disable them
# when this script gets called
# [on install or on update].
DISABLED="true"

function configure()
{
  printf "ID=%02u\t%-24s\t%-24s\t%s\t%s\n" "$ID" "$NAME" "$DISTRIBUTION" "$GIT_REPO" "$BRANCH_NAME"
  test -d "$JOBS_DIR/$NAME" || mkdir -p "$JOBS_DIR/$NAME" || exit 1
  sed "s!@@SUBDIR@@!$SUBDIR!g;
       s!@@GIT_REPO@@!$GIT_REPO!g;
       s!@@DISTRIBUTION@@!$DISTRIBUTION!g;
       s!@@DISABLED@@!$DISABLED!g;
       s!@@BRANCH_NAME@@!$BRANCH_NAME!g;
       s!@@ID@@!$ID!g;
       s!@@NANNY@@!$NANNY!g" \
      config-job.template > "$JOBS_DIR/$NAME/config.xml"
}

DISTRIBUTION="SLES 12 SP1 (x86_64)"
BRANCH_NAME="master"
NANNY="without"
NAME=wicked-master
ID=1
configure

DISTRIBUTION="SLES 12 SP1 (x86_64)"
BRANCH_NAME="master"
NANNY="with"
NAME=wicked-master-nanny
ID=2
configure

DISTRIBUTION="SLES 12 SP1 (x86_64)"
BRANCH_NAME="testing"
NANNY="without"
NAME=wicked-testing
ID=3
configure

DISTRIBUTION="SLES 12 SP1 (x86_64)"
BRANCH_NAME="testing"
NANNY="with"
NAME=wicked-testing-nanny
ID=4
configure

DISTRIBUTION="SLES 12 SP0 (x86_64)"
BRANCH_NAME="sle12"
NANNY="without"
NAME=wicked-sle12
ID=5
configure

DISTRIBUTION="SLES 12 SP0 (x86_64)"
BRANCH_NAME="sle12"
NANNY="with"
NAME=wicked-sle12-nanny
ID=6
configure

