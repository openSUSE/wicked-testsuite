#! /bin/bash

BUILD_HOST="build"
LOWERDEVS="true"
PRECISE="false"
SUT_TARGET="virtio:/var/run/twopence/sut.sock"
REF_TARGET="virtio:/var/run/twopence/reference.sock"
SUBDIR="cucumber/"

function configure()
{
  sed "s!@@BUILD_HOST@@!$BUILD_HOST!g;
       s!@@LOWERDEVS@@!$LOWERDEVS!g;
       s!@@PRECISE@@!$PRECISE!g;
       s!@@SUT_TARGET@@!$SUT_TARGET!g;
       s!@@REF_TARGET@@!$REF_TARGET!g;
       s!@@SUBDIR@@!$SUBDIR!g;
       s!@@GIT_REPO@@!$GIT_REPO!g;
       s!@@BRANCH_NAME@@!$BRANCH_NAME!g;
       s!@@NANNY@@!$NANNY!g" \
      config-xml.template > /var/lib/jenkins/jobs/$NAME/config.xml
}

GIT_REPO="openSUSE"
BRANCH_NAME="master"
NANNY="without"
NAME=wicked-master
configure

GIT_REPO="openSUSE"
BRANCH_NAME="master"
NANNY="with"
NAME=wicked-master-nanny
configure

GIT_REPO="openSUSE"
BRANCH_NAME="testing"
NANNY="without"
NAME=wicked-testing
configure

GIT_REPO="openSUSE"
BRANCH_NAME="testing"
NANNY="with"
NAME=wicked-testing-nanny
configure

GIT_REPO="openSUSE"
BRANCH_NAME="sle12"
NANNY="without"
NAME=wicked-sle12
configure

GIT_REPO="openSUSE"
BRANCH_NAME="sle12"
NANNY="with"
NAME=wicked-sle12-nanny
configure

