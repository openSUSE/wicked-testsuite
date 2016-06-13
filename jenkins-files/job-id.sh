#!/bin/bash

job_basedir="/var/lib/jenkins/jobs"
job_id_lock="$job_basedir/.id.lock"
job_id_min=1
job_id_max=49

job_exists()
{
	local name="$1"
	test "x$name" != x -a -d "$job_basedir/$name"
}

job_id_unlock()
{
	test -d "$job_basedir"  || return 0
	rm -f -- "$job_id_lock/pid" 2>/dev/null
	rmdir -- "$job_id_lock"
	trap -- - EXIT
}

job_id_lock()
{
	local try pid ret

	test -d "$job_basedir" || return 1
	for ((try = 0; try < 40; try++)) ; do
		if mkdir -- "$job_id_lock" 2>/dev/null ; then
			echo "$$" > "$job_id_lock/pid" 2>/dev/null
			trap -- job_id_unlock EXIT
			return 0
		else
			sleep 0.25
		fi
	done

	read pid 2>/dev/null < "$job_id_lock/pid"
	echo >&2 "job id lock is already set${pid:+ by process $pid}"

	return 2
}

job_id_read()
{
	local id ret name="$1"
	read id 2>/dev/null < "$job_basedir/$name/id" ; ret=$?
	echo "$id"
	return $ret
}

job_id_write()
{
	local nc ret name="$1" id="$2"

	job_exists "$name" || return 1
	shopt -o -q noclobber ; nc=$?
	test $nc && shopt -o -s noclobber
	echo "$id" > "$job_basedir/$name/id" ; ret=$?
	test $nc && shopt -o -u noclobber
	return $ret
}

job_id_list()
{
	local ng id fn
	local list=()

	shopt -q nullglob ; ng=$?
	[ $ng ] && shopt -s nullglob
	for fn in "$job_basedir"/*/id ; do
		read id 2>/dev/null < "$fn"
		test -n "$id" && list+=("$id")
	done
	test ${#list[@]} -gt 0 && echo "${list[@]}"
	[ $ng ] && shopt -u nullglob
}

job_id_valid()
{
	local -i id="$1"
	test "$id" -ge "$job_id_min" -a "$id" -le "$job_id_max"
}

job_id_unused()
{
	local want="$1" ; shift

	for id in "$@" ; do
		test "x$id" = "x$want" && return 1
	done
	return 0
}

job_id()
{
	local list id name="$1" want="$2"

	id=$(job_id_read "$name")
	if test -n "$id" ; then
		echo "$id"
		return 0
	fi

	list=(`job_id_list`)
	if job_id_valid "$want" 2>/dev/null ; then
		for id in ${list[@]} ; do
			test "x$id" = "x$want" || continue
			unset want
			break
		done

		if test -n "$want" ; then
			job_id_write "$name" "$want" || return 1

			echo "$want"
			return 0
		fi
	fi
	for ((want=job_id_min; want<=job_id_max; want++)) ; do
		for id in ${list[@]} ; do
			test "x$id" = "x$want" && continue 2
		done
		job_id_write "$name" "$want" || return 1
		echo "$want"
		return 0
	done

	echo >&2 "Unable to aquire free ID for job name \"$name\" -- all in use"
	return 1
}

NAME=$1
ID=$2

job_id_lock || exit 1
if job_exists "$NAME" ; then
	job_id "$NAME" "$ID"
else
	echo >&2 "job name \"$NAME\" does not exist"
fi
job_id_unlock

