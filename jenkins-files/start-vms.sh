#! /bin/bash
#
# Start the VMs for manual testing
#
# Assumes that wicked has already been build for that project

name=$1
id=$2

if [ "$name" = "" -o "$id" = "" ]; then
  echo "Usage: $0 <suite name> <suite id>"
  echo "Example: $0 wicked-master 1"
  exit 1
fi

# Parameters

ref=openSUSE_13_1-x86_64.qcow2
ref_arch=x86_64

sut=SLES_12_SP0-x86_64.qcow2
sut_arch=x86_64

nanny=with

# Start the VMs and networks

scripts=$(dirname $0)

images=/var/lib/libvirt/images
jenkins=/var/lib/jenkins

export WORKSPACE=$jenkins/jobs/$name/workspace

rm -f $WORKSPACE/*.qcow2
cp $images/ref/$ref $WORKSPACE/ref.qcow2
cp $images/sut/$sut $WORKSPACE/sut.qcow2

$scripts/config-net.sh $name $id 0
$scripts/config-net.sh $name $(($id+50)) 1
$scripts/config-ref.sh $name $id $ref_arch
$scripts/config-sut.sh $name $id $sut_arch

## Wait until we can communicate with the test machines

target_sut=virtio:/var/run/twopence/sut-$name.sock
target_ref=virtio:/var/run/twopence/ref-$name.sock

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

# Inject wicked

for pkg in $(ls $WORKSPACE/RPMs); do
  twopence_inject $target_sut $WORKSPACE/RPMs/$pkg /root/$pkg
done

twopence_command $target_sut "service wicked stop"
twopence_command $target_sut "service wickedd stop"

twopence_command $target_sut "rpm -qc wicked > /tmp/config-files"
twopence_command $target_sut "rpm -e --nodeps \$(rpm -qa \"*wicked*\")"
twopence_command $target_sut "rm -f \$(cat /tmp/config-files)"
twopence_command $target_sut "rpm -ih /root/*wicked*.$sut_arch.rpm"

twopence_inject $target_sut $jenkins/cucumber/jenkins-files/wicked-$nanny-nanny.xml /etc/wicked/local.xml
twopence_command $target_sut "chmod u=rw,go=r /etc/wicked/local.xml"

twopence_command $target_sut "service wickedd start"
twopence_command $target_sut "service wicked start"

