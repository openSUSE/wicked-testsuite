#! /bin/bash

SUBDIR="cucumber"
GIT_REPO="openSUSE"

function configure()
{
  sed "s!@@SUBDIR@@!$SUBDIR!g;
       s!@@GIT_REPO@@!$GIT_REPO!g;
       s!@@BRANCH_NAME@@!$BRANCH_NAME!g;
       s!@@ID@@!$ID!g;
       s!@@NANNY@@!$NANNY!g" \
      config-job.template > /var/lib/jenkins/jobs/$NAME/config.xml
}

BRANCH_NAME="master"
NANNY="without"
NAME=wicked-master
ID=1
configure

BRANCH_NAME="master"
NANNY="with"
NAME=wicked-master-nanny
ID=2
configure

BRANCH_NAME="testing"
NANNY="without"
NAME=wicked-testing
ID=3
configure

BRANCH_NAME="testing"
NANNY="with"
NAME=wicked-testing-nanny
ID=4
configure

BRANCH_NAME="sle12"
NANNY="without"
NAME=wicked-sle12
ID=5
configure

BRANCH_NAME="sle12"
NANNY="with"
NAME=wicked-sle12-nanny
ID=6
configure

