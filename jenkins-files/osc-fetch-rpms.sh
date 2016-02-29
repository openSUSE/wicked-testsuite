#! /bin/bash
#
set -x -e

scripts=$(dirname $(readlink -m $0))

### Fetch wicked rpms from build system proj/pkg

bs_api="$1"
bs_pkg="$2"
bs_proj="$3"
bs_repo="$4"
bs_arch="$5"
flags="$6"

test "x$bs_api" != "x"
test "x$bs_pkg" != "x"
test "x$bs_proj" != "x"
test "x$bs_repo" != "x"
test "x$bs_arch" != "x"

test "x$WORKSPACE" != "x" && cd "$WORKSPACE"

_repo=
_arch=
dirty=
repo_state=
build_state=
details=

IFS='|' read _repo _arch repo_state dirty build_state details \
< <(osc -A $bs_api results --csv -v -l \
	-r "${bs_repo}" -a "${bs_arch}" "${bs_proj}" "${bs_pkg}")

:
: $project $package $_repo $_arch $repo_state $dirty $build_state $details
:
if [[ $flags =~ bs_check_success ]] ; then
	test "X$_repo" = "X$bs_repo" -a \
	     "X$_arch" = "X$bs_arch" -a \
	     "X$dirty" = "XFalse" -a \
	     "X$repo_state" = "Xpublished" -a \
	     "X$build_state" = "Xsucceeded"
fi

if [[ $flags =~ bs_remove_rpms ]] ; then
	rm -rf -- "${WORKSPACE}/RPMs"
	rm -rf -- "${WORKSPACE}/RPMs.old"
fi

if test -d "${WORKSPACE}/RPMs" ; then
	rm -rf -- "${WORKSPACE}/RPMs.old"
	mv -f "${WORKSPACE}/RPMs" "${WORKSPACE}/RPMs.old"
else
	mkdir -- "${WORKSPACE}/RPMs.old"
fi

osc -A $bs_api getbinaries --debug --sources -d "${WORKSPACE}/RPMs" \
	"${bs_proj}" "${bs_pkg}" "${bs_repo}" "${bs_arch}"

diff --brief -urN \
	"${WORKSPACE}/RPMs.old" "${WORKSPACE}/RPMs" || : show only

