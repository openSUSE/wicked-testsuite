#! /bin/bash

ID=0
SUBDIR="cucumber"
GIT_REPO="openSUSE"
JOBS_DIR=/var/lib/jenkins/jobs
# do not auto-enable all jobs;
# better to auto-disable them
# when this script gets called
# [on install or on update].
DISABLED="true"

dry_run=no
while [ $# -gt 0 ]; do
	case $1 in
	--dry-run)	shift;	dry_run=yes			;;
	-*)		echo 1>&2 "unknown option $1" ; exit 1	;;
	*)		break					;;
	esac
done

function configure()
{
  printf "ID=%02u\t%-24s\t%-24s\t%s\t%s\n" "$ID" "$NAME" "$DISTRIBUTION" "$GIT_REPO" "$BRANCH_NAME"
  test "x$dry_run" = "xyes" && return 0
  test -d "$JOBS_DIR/$NAME" || mkdir -p "$JOBS_DIR/$NAME" || exit 1
  sed "s!@@SUBDIR@@!$SUBDIR!g;
       s!@@GIT_REPO@@!$GIT_REPO!g;
       s!@@DISTRIBUTION@@!$DISTRIBUTION!g;
       s!@@DISABLED@@!$DISABLED!g;
       s!@@BRANCH_NAME@@!$BRANCH_NAME!g;
       s!@@ID@@!$ID!g;
       s!@@NANNY@@!$NANNY!g" \
      config-job.template > "$JOBS_DIR/$NAME/config.xml"
}

if test -n "$HOSTNAME" ; then
	if test -f "$HOSTNAME/config-job.sh" ; then
		source "$HOSTNAME/config-job.sh"
	else
		source "default/config-job.sh"
	fi
else
	echo >&2 "The HOSTNAME environment variable is not set"
	exit 1
fi

