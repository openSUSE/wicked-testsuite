#! /bin/bash
#
# Build and run wicked
#
# Parameters from Jenkins:
#   $WORKSPACE
#   $JOB_NAME
#   $BUILD_NUMBER
#
# Parameters from test suite, chosen by user:
#   $DISTRIBUTION
#     SLES 12 SP0 (x86_64)
#     openSUSE 13.2 (x86_64)
#     openSUSE 13.2 (i586)
#     openSUSE Tumbleweed (x86_64)
#     Physical
#   $CONFIGURE_LOWERDEVS
#     true
#     false
#   $CONFIGURE_PRECISE
#     true
#     false
#
# Parameters from test suite, fixed:
#   $NANNY
#     with
#     without
#   $SUBDIR
#     cucumber
#     playground-cucumber
#   $ID
#     a unique numerical identifier

set -x -e

scripts=$(dirname $(readlink -m $0))

### Determine build options and target test system

case "$DISTRIBUTION" in
  "SLES 12 SP0 (x86_64)")
    bs_api=ibs
    bs_proj=SUSE:SLE-12:Update
    bs_repo=standard
    bs_arch=x86_64
    sut=SLES_12_SP0-x86_64.qcow2
    ref=openSUSE_13_1-x86_64.qcow2
    vm_arch=x86_64
    ;;
  "openSUSE 13.2 (x86_64)")
    bs_api=obs
    bs_proj=openSUSE:13.2:Update
    bs_repo=standard
    bs_arch=x86_64
    sut=openSUSE_13_2-x86_64.qcow2
    ref=openSUSE_13_1-x86_64.qcow2
    vm_arch=x86_64
    ;;
  "openSUSE 13.2 (i586)")
    bs_api=obs
    bs_proj=openSUSE:13.2:Update
    bs_repo=standard
    bs_arch=i586
    sut=openSUSE_13_2-i686.qcow2
    ref=openSUSE_13_1-x86_64.qcow2
    vm_arch=i686
    ;;
  "openSUSE Tumbleweed (x86_64)")
    bs_api=obs
    bs_proj=openSUSE:Tumbleweed
    bs_repo=standard
    bs_arch=x86_64
    sut=openSUSE_Tumbleweed-x86_64.qcow2
    ref=openSUSE_13_1-x86_64.qcow2
    vm_arch=x86_64
    ;;
  "Physical")
    bs_api=ibs
    bs_proj=SUSE:SLE-12:Update
    bs_repo=standard
    bs_arch=x86_64
    target_sut="ssh:10.161.8.133"
    target_ref="ssh:10.161.8.239"
    ;;
  *)
    false
    ;;
esac
[ "$sut" = "" ] || target_sut="virtio:/var/run/twopence/sut-${JOB_NAME}.sock"
[ "$ref" = "" ] || target_ref="virtio:/var/run/twopence/ref-${JOB_NAME}.sock"

### Prepare VMs or physical machines

if [ "$ref" = "" ]; then
  twopence_command $target_ref "ip neigh flush all"
else
  $scripts/config-net.sh $JOB_NAME $ID 0
  $scripts/config-net.sh $JOB_NAME $(($ID+50)) 1
  rm -f $WORKSPACE/ref.qcow2
  cp /var/lib/jenkins/images/ref-$ref $WORKSPACE/ref.qcow2
  $scripts/config-ref.sh $JOB_NAME $ID x86_64
fi

if [ "$sut" = "" ]; then
  twopence_command $target_sut "rm -f /core*"
  twopence_command $target_sut "rm -r /var/log/journal/*; systemctl restart systemd-journald"
  twopence_command $target_sut "rm -f /root/*wicked*.rpm"
else
  rm -f $WORKSPACE/sut.qcow2
  cp /var/lib/jenkins/images/sut-$sut $WORKSPACE/sut.qcow2
  $scripts/config-sut.sh $JOB_NAME $ID $vm_arch
fi

### Build wicked with Open Build Service

cd $WORKSPACE
rm -rf SRCs RPMs
mkdir SRCs RPMs

./autogen.sh
make dist
cp wicked-*.tar.bz2 wicked-rpmlintrc wicked.spec SRCs
ls -lh SRCs

pushd SRCs
release=$BUILD_NUMBER.$(date +%Y%m%d%H%M%S)
osc -A $bs_api build \
  --clean --local-package --debuginfo \
  --release=$release \
  --alternative-project $bs_proj \
  --root $WORKSPACE/build-root/$bs_repo-$bs_arch \
  $bs_repo $bs_arch wicked.spec
popd

rpms_out=$WORKSPACE/build-root/$bs_repo-$bs_arch/home/abuild/rpmbuild
cp -a $rpms_out/RPMS/$bs_arch/*wicked*-$release.$bs_arch.rpm RPMs/
ls -lh RPMs

## Wait until we can communicate with the test machines
while true; do
  who=$(twopence_command -b $target_ref "whoami")
  [ "$who" = "root" ] && break
  sleep 1
done

while true; do
  who=$(twopence_command -b $target_sut "whoami")
  [ "$who" = "root" ] && break
  sleep 1
done

### Run the tests

for pkg in $(ls RPMs); do
  twopence_inject $target_sut RPMs/$pkg /root/$pkg
done

twopence_command $target_sut "service wicked stop"
twopence_command $target_sut "service wickedd stop"

twopence_command $target_sut "rpm -qc wicked > /tmp/config-files"
twopence_command $target_sut "rpm -e --nodeps \$(rpm -qa \"*wicked*\")"
twopence_command $target_sut "rm -f \$(cat /tmp/config-files)"
twopence_command $target_sut "rpm -ih /root/*wicked*-$release.$bs_arch.rpm"

twopence_inject $target_sut /var/lib/jenkins/cucumber/jenkins-files/wicked-$NANNY-nanny.xml /etc/wicked/local.xml
twopence_command $target_sut "chmod u=rw,go=r /etc/wicked/local.xml"

twopence_command $target_sut "service wickedd start"
twopence_command $target_sut "service wicked start"

pushd /var/lib/jenkins/$SUBDIR
tar czf $WORKSPACE/test-suite.tgz features/ test-files/

failed="no"
export TARGET_SUT=$target_sut
export TARGET_REF=$target_ref
cucumber -f Cucumber::Formatter::JsonExpanded --out $WORKSPACE/wicked.json || failed="yes"

twopence_extract $target_sut "/tmp/wicked-log.tgz" "$WORKSPACE/wicked-log.tgz"
popd

### Remove VMs, but only if the tests did not fail

if [ "$failed" = "no" ]; then
  if [ "$ref" != "" ]; then
    sudo virsh destroy ref-$JOB_NAME
    sudo virsh undefine ref-$JOB_NAME
    rm $WORKSPACE/ref.qcow2
  fi

  if [ "$sut" != "" ]; then
    sudo virsh destroy sut-$JOB_NAME
    sudo virsh undefine sut-$JOB_NAME
    rm $WORKSPACE/sut.qcow2
    sudo virsh net-destroy $JOB_NAME-0
    sudo virsh net-undefine $JOB_NAME-0
    sudo virsh net-destroy $JOB_NAME-1
    sudo virsh net-undefine $JOB_NAME-1
  fi
fi
