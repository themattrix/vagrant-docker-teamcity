#!/bin/bash

# First, make sure that cgroups are mounted correctly.
CGROUP=/sys/fs/cgroup

[ -d $CGROUP ] || 
	mkdir $CGROUP

mountpoint -q $CGROUP || 
	mount -n -t tmpfs -o uid=0,gid=0,mode=0755 cgroup $CGROUP || {
		echo "Could not make a tmpfs mount. Did you use -privileged?"
		exit 1
	}

# Mount the cgroup hierarchies exactly as they are in the parent system.
for SUBSYS in $(cut -d: -f2 /proc/1/cgroup)
do
	[ -d $CGROUP/$SUBSYS ] || mkdir $CGROUP/$SUBSYS
	mountpoint -q $CGROUP/$SUBSYS || 
		mount -n -t cgroup -o $SUBSYS cgroup $CGROUP/$SUBSYS
done

# Note: as I write those lines, the LXC userland tools cannot setup
# a "sub-container" properly if the "devices" cgroup is not in its
# own hierarchy. Let's detect this and issue a warning.
grep -q :devices: /proc/1/cgroup ||
	echo "WARNING: the 'devices' cgroup should be in its own hierarchy."
grep -qw devices /proc/1/cgroup ||
	echo "WARNING: it looks like the 'devices' cgroup is not mounted."

# Now, close extraneous file descriptors.
pushd /proc/self/fd
for FD in *
do
	case "$FD" in
	# Keep stdin/stdout/stderr
	[012])
		;;
	# Nuke everything else
	*)
		eval exec "$FD>&-"
		;;
	esac
done
popd

exit 0

# If we were given a PORT environment variable, start as a simple daemon;
# otherwise, spawn a shell as well
#if [ "$PORT" ]
#then
#	exec docker -d -H 0.0.0.0:$PORT
#else
#
#	docker -d &
#	exec bash
#fi
