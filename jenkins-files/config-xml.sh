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

