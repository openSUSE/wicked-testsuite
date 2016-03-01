#
# this file contains the default jobs,
# $HOSTNAME/config-job.sh may override
#

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

