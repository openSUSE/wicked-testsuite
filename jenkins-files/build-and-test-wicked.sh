#! /bin/bash
#
# Build and run wicked
#
# Parameters from Jenkins:
#   $WORKSPACE
#   $BUILD_NUMBER
#
# Parameters from test suite:
#   $DISTRIBUTION
#     sles 12 sp0 (x86_64)
#     opensuse 13.2 (x86_64)
#     opensuse 13.2 (i586)
#     opensuse factory (x86_64)
#     opensuse tumbleweed (x86_64)
#     physical
#   $CONFIGURE_LOWERDEVS
#     true
#     false
#   $CONFIGURE_PRECISE
#     true
#     false
#   $NANNY
#     with
#     without
#   $SUBDIR
#     cucumber
#     playground-cucumber

set -x -e

### Build wicked with OBS

case "$DISTRIBUTION" in
  "SLES 12 SP0 (x86_64)")
    bs_api=ibs
    bs_proj=SUSE:SLE-12:Update
    bs_repo=standard
    bs_arch=x86_64
    target_sut=virtio:/var/run/twopence/suites-sut-SLES_12_SP0-x86_64.sock
    target_ref=virtio:/var/run/twopence/suites-ref-openSUSE_13_1-x86_64.sock
    ;;
  "openSUSE 13.2 (x86_64)")
    bs_api=obs
    bs_proj=openSUSE:13.2:Update
    bs_repo=standard
    bs_arch=x86_64
    target_sut=virtio:/var/run/twopence/suites-sut-openSUSE_13_2-x86_64.sock
    target_ref=virtio:/var/run/twopence/suites-ref-openSUSE_13_1-x86_64.sock
    ;;
  "openSUSE 13.2 (i586)")
    bs_api=obs
    bs_proj=openSUSE:13.2:Update
    bs_repo=standard
    bs_arch=i586
    target_sut=virtio:/var/run/twopence/suites-sut-openSUSE_13_2-i586.sock
    target_ref=virtio:/var/run/twopence/suites-ref-openSUSE_13_1-x86_64.sock
    ;;
  "openSUSE Factory (x86_64)")
    bs_api=obs
    bs_proj=openSUSE:Factory
    bs_repo=standard
    bs_arch=x86_64
    target_sut=virtio:/var/run/twopence/suites-sut-openSUSE_Factory-x86_64.sock
    target_ref=virtio:/var/run/twopence/suites-ref-openSUSE_13_1-x86_64.sock
    ;;
  "openSUSE Tumbleweed (x86_64)")
    bs_api=obs
    bs_proj=openSUSE:Tumbleweed
    bs_repo=standard
    bs_arch=x86_64
    target_sut=virtio:/var/run/twopence/suites-sut-openSUSE_Tumbleweed-x86_64.sock
    target_ref=virtio:/var/run/twopence/suites-ref-openSUSE_13_1-x86_64.sock
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
  $bs_repo $bs_arch wicked.spec
popd

rpms_out=/var/tmp/build-root/$bs_repo-$bs_arch/home/abuild/rpmbuild
cp -a $rpms_out/RPMS/$bs_arch/*wicked*-$release.$bs_arch.rpm RPMs/
ls -lh RPMs

### Run the tests

twopence_command $target_sut "rm -f /root/*.rpm"
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

# twopence_command $TARGET_SUT "rm -rf /core* /root/coredumps/*.tgz /root/coredumps/*.txt"
twopence_command $target_sut "rm -r /var/log/journal/*; systemctl restart systemd-journald"

pushd /var/lib/jenkins/$SUBDIR
tar czf $WORKSPACE/test-suite.tgz features/ test-files/

export TARGET_SUT=$target_sut
export TARGET_REF=$target_ref
cucumber -f Cucumber::Formatter::JsonExpanded --out $WORKSPACE/wicked.json || true

twopence_extract $target_sut "/tmp/wicked_log.tgz" "$WORKSPACE/wicked_log.tgz"

# coredumps=$(twopence_command $TARGET_SUT "/root/bin/get-core-dump-ls.sh" | awk -- '/^[/]root[/]coredumps/ { print $0; }')
# if test "X$coredumps" != X ; then
#   for c in $coredumps ; do
#     b=$(basename -- "$c")
#     twopence_extract $TARGET_SUT "$c" "$b"
#     twopence_command $TARGET_SUT "rm -f -- $c"
#   done
# fi
popd

ls -lh test-suite.tgz wicked_log.tgz
