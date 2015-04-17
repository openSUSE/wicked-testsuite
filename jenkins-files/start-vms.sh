#! /bin/bash
#
# Start the VMs for manual testing
#
# This script assumes that wicked has already been build for that project

function invalid_param
{
  echo "Invalid value" >&2
  exit 1
}

scripts=$(dirname $0)

images=/var/lib/libvirt/images
jenkins=/var/lib/jenkins
subdir=cucumber

# Read parameters

echo -n "                Test suite name: "
read -e -i "wicked-master" name
[ "$subdir" = "cucumber" ] && jobname="$name" || jobname="playground-$name"
[ -d $jenkins/jobs/$jobname ] || invalid_param

echo -n "                  Test suite ID: "
read -e -i "1" id
[[ "$id" =~ ^[0-9]+$ ]] || invalid_param

echo -n "   Reference machine disk image: "
read -e -i "openSUSE_13_1-x86_64.qcow2" ref
[ -f $images/ref/$ref ] || invalid_param

echo -n " Reference machine architecture: "
read -e -i "x86_64" ref_arch
[ "$ref_arch" = "x86_64" -o "$ref_arch" = "i586" ] || invalid_param

echo -n "  System under tests disk image: "
read -e -i "SLES_12_SP0-x86_64.qcow2" sut
[ -f $images/sut/$sut ] || invalid_param

echo -n "System under tests architecture: "
read -e -i "x86_64" sut_arch
[ "$sut_arch" = "x86_64" -o "$sut_arch" = "i586" ] || invalid_param

echo -n "              With/without nanny "
read -e -i "with" nanny
[ "$nanny" = "with" -o "$nanny" = "without" ] || invalid_param

# Start the VMs and networks

export WORKSPACE=$jenkins/jobs/$jobname/workspace

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

twopence_inject $target_sut $jenkins/$subdir/jenkins-files/wicked-$nanny-nanny.xml /etc/wicked/local.xml
twopence_command $target_sut "chmod u=rw,go=r /etc/wicked/local.xml"

twopence_command $target_sut "service wickedd start"
twopence_command $target_sut "service wicked start"

