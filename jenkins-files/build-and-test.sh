#! /bin/bash

export WORKSPACE="/var/lib/jenkins/jobs/wicked-testing/workspace/"
export JOB_NAME="wicked-testing"

export TARGET_REF="virtio:/var/run/twopence/ref-wicked-testing.sock"
export TARGET_SUT="virtio:/var/run/twopence/sut-wicked-testing.sock"

export DISTRIBUTION="SLES 12 SP0 (x86_64)"
export CONFIGURE_LOWERDEVS="true"
export CONFIGURE_PRECISE="false"
export NANNY="without"
export SUBDIR="cucumber"
export ID="3"

./build-and-test-wicked.sh
