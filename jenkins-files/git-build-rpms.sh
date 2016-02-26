#! /bin/bash
#
set -x -e

scripts=$(dirname $(readlink -m $0))

### Build wicked from git repository sources in workspace

bs_api="$1"
bs_pkg="$2"
bs_proj="$3"
bs_repo="$4"
bs_arch="$5"
flags="$6"

test "x$bs_api" != "x"
test "x$bs_pkg" != "x" # ignored
test "x$bs_proj" != "x"
test "x$bs_repo" != "x"
test "x$bs_arch" != "x"

test "x$JOB_NAME" != "x"
test "x$BUILD_NUMBER" != "x"
test "x$BUILD_ROOT_PREFIX" != "x"

test "x$WORKSPACE" != "x" && cd "$WORKSPACE"

rm -rf SRCs RPMs
rm -rf wicked-*.tar.bz2 wicked-rpmlintrc wicked.spec
mkdir SRCs RPMs

./autogen.sh
make dist
cp wicked-*.tar.bz2 wicked-rpmlintrc wicked.spec SRCs
ls -lh SRCs

pushd SRCs
release=$BUILD_NUMBER.$(date +%Y%m%d%H%M%S)
osc -A $bs_api build \
  --clean --local-package --debuginfo --trust-all-projects \
  --release=$release \
  --alternative-project $bs_proj \
  --root $BUILD_ROOT_PREFIX/$JOB_NAME/$bs_repo-$bs_arch \
  $bs_repo $bs_arch wicked.spec
popd

rpms_out=$BUILD_ROOT_PREFIX/$JOB_NAME/$bs_repo-$bs_arch/home/abuild/rpmbuild
cp -a $rpms_out/RPMS/$bs_arch/*wicked*-$release.$bs_arch.rpm RPMs/
ls -lh RPMs

