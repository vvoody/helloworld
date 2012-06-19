#!/bin/sh

# Usage: head -140 ChangeLog.txt | $0
# pkgbase() and package_name() are from Slackware pkgtools package.

pkgbase() {
	PKGEXT=$(echo $1 | rev | cut -f 1 -d . | rev)
	case $PKGEXT in
		'tgz' )
		PKGRETURN=$(basename $1 .tgz)
		;;
		'tbz' )
		PKGRETURN=$(basename $1 .tbz)
		;;
		'tlz' )
		PKGRETURN=$(basename $1 .tlz)
		;;
		'txz' )
		PKGRETURN=$(basename $1 .txz)
		;;
		*)
		PKGRETURN=$(basename $1)
		;;
	esac
	echo $PKGRETURN
}

package_name() {
	STRING=$(pkgbase $1)
	# Check for old style package name with one segment:
	if [ "$(echo $STRING | cut -f 1 -d -)" = "$(echo $STRING | cut -f 2 -d -)" ]; then
		echo $STRING
	else # has more than one dash delimited segment
		# Count number of segments:
		INDEX=1
		while [ ! "$(echo $STRING | cut -f $INDEX -d -)" = "" ]; do
			INDEX=$(expr $INDEX + 1)
		done
		INDEX=$(expr $INDEX - 1) # don't include the null value
		# If we don't have four segments, return the old-style (or out of spec) package name:
		if [ "$INDEX" = "2" -o "$INDEX" = "3" ]; then
			echo $STRING
		else # we have four or more segments, so we'll consider this a new-style name:
			NAME=$(expr $INDEX - 3)
			NAME="$(echo $STRING | cut -f 1-$NAME -d -)"
			echo $NAME
			# cruft for later ;)
			#VER=$(expr $INDEX - 2)
			#VER="$(echo $STRING | cut -f $VER -d -)"
			#ARCH=$(expr $INDEX - 1)
			#ARCH="$(echo $STRING | cut -f $ARCH -d -)"
			#BUILD="$(echo $STRING | cut -f $INDEX -d -)"
		fi
	fi
}

for p in `grep -v -e "extra/" -e "testing/" -e "pasture/" -e "Removed\." $1 | egrep -o "[^/]*t[gx]z"`; do
	package_name $p
done
