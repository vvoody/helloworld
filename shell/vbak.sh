#!/bin/bash
#
# Copyright (C) 2008-3001, vvoody <wxj.g.sh{AT}gmail.com>
# Released under GNU GPL v3.
#
# vbak first finished without test strongly at 2008-10-20 night
# vbak can be for daily use, I think, at 2008-10-27 night
#
# Get the latest version:
# svn checkout http://vvoodys.googlecode.com/svn/trunk/vbak vbak
#
# TODO:
#     remove the temp files periodically;
#     find a easy to remove one line from file;

# die $exit_code $last_words
function die() {
    result=$1
    shift
    printf "%s\n" "$*" >&2
    exit $result
}

function usage() {
    die 1 'Try to run "vbak help [-t] for help.'
}

function show_help() {
    if [ -z $1 ]; then
	echo "Usage: qbak [COMMAND] [OPTION] ..."
	echo "Commands are:"
	echo -e "\thelp\tadd\tremove\tupdate"
	echo -e "\tlist\tfiles\tclear\tcheckout/co"
	echo
	echo 'See more info: "vbak help -t"'
    elif [ $1 == "-t" ]; then
	echo "We have only *one* option: '-t'"
	echo "Please put the '-t' option just after the COMMAND."
	echo
	echo "Command HELP can be with '-t', or without."
	echo "$ vbak help"
	echo "$ vbak help -t"
	echo
	echo "Command LIST and FILES can use '-t' option with its value, or none."
	echo "$ vbak list -t emacs"
	echo "$ vbak files"
	echo
	echo "Command REMOVE, UPDATE and can have '-t' option with its value, "
	echo " or alternatively have its arguments."
	echo "$ vbak remove .bashrc .lftp"
	echo "$ vbak update -t network"
	echo
	echo "Command ADD must have its arguments."
	echo "You can also use '-t' option with its *only* one value."
	echo "$ add .emacs .bashrc .mplayer/"
	echo "$ add -t opera opera6.ini opera6.adr wand.dat usejs/"
	echo
	echo "Command CHECKOUT(or CO) and CLEAR can only use like:"
	echo "$ vbak clear"
	echo "$ vbak co -t rc.3"
	echo
    else
	die 1 "Panic: Unrecognized option. Only you can use is '-t'."
    fi
    exit 0
}

# check_files $file1 $file2 ...
# Check if files exist, else create it.
function check_files() {
    check=0
    for file
    do
	[ -f "$file" ] && continue ||
	touch "$file" || check=1
    done
    return $check
}

# Read the variable VBAK_OUT_DIR setting.
function check_config() {
    out_dir=$(grep "$1" $2 | sed 's/^.*= *//')
    return $out_dir
}

# Get the tag name and set TAGNAME
function get_tag_name() {
    if [ "$1" == "-t" ]; then
	if [ -f "$2" ]; then
	    die 1 "You should define the tag name after '-t'."
	else
	    TAGNAME="$2"
	    export TAGNAME
	fi
    fi
}

# We will use the encoded file name as the backup file's name.
# e.g. /home/vvoody/dic.txt --> home-vvoody-dic.txt
function encode_file_name() {
	#echo $1 >&2
	tmp0=`echo $1 | sed -e 's/\-/\\\-/g'`
	#echo $tmp0 >&2
	tmp1=`echo $tmp0 | sed -e 's#/#\-#g'`
	#echo $tmp1 >&2
	tmp2=`echo $tmp1 | sed -e 's/^\-//g'`
	echo $tmp2
	return 0
}

# .emacs -> /home/vvoody/.emacs
# Called by do_add and case
function full_file_name() {
    f_name=""
    foo=$(echo "$1" | sed -e 's/\/$//g')
    # no '/' tail
    if echo "$foo" | egrep "^/" >/dev/null ; then
	f_name="$foo"
    else
	f_name="$PWD/${foo}"
    fi
    echo "$f_name"
}

# remove_line which_line
# called by do_remove and do_add
# This is too bad and ugly, I wanna use sed!
function remove_line() {
    tmp=$(mktemp /tmp/vbak.$RANDOM.XXXXXXX) || return 2
    egrep -v "$1" "$list_file" > $tmp
    cat $tmp > "$list_file"
}

# Backup the files/dirs, and add them to the file.list
function do_add() {
    full_name=$(full_file_name "$1")
    # Maybe you are adding a file which already backuped.
    egrep "$full_name" "$list_file"
    if [ $? -eq 0 ]; then
	echo -n "You have already backuped this file, backup again?(y/n)"
	read y_or_n
	if [ $y_or_n = "y" ]; then
	    remove_line "$full_name";
	else
	    return 0
	fi
    fi

    # backup( copy directly to $VBAK_OUT_DIR), add file information to file.list
    if [ ! -z "$full_name" ]; then
	echo "$full_name"
	name=$(encode_file_name "$full_name") || return 1
	echo $name
	cp -rf "$full_name" "$VBAK_OUT_DIR/$name" || return 2
	echo "$full_name" "@${TAGNAME}@" >> "$list_file" || return 3
    else
	die 4 "Backup failed!"
    fi
    return 0
}

# backuped files in the VBAK_OUT_DIR
# do_list [-t TAG]
function do_list() {
    if [ -z "$TAGNAME" ]; then
	tmp="$list_file"
	sed -i 's/@.*@//g' "$tmp"
#	ls -1 -t $VBAK_OUT_DIR | egrep -v "file.list"
    else
	tmp=$(mktemp /tmp/vbak.$RANDOM.XXXXXXX) || return 2
	egrep "$TAGNAME" "$list_file" | sed 's/@.*@//g' > $tmp
    fi
    while read line
    do
	file_bak_name=$(encode_file_name "$line") || return 3
	if [ -e "${VBAK_OUT_DIR}/${file_bak_name}" ]; then
	    echo "$file_bak_name"
	else
	    echo -n "$file_bak_name "
	    echo -e ${red}"*MISSED!*"${clr_normal}
	fi
    done < "$tmp"
    return $?
}

# The genuine files
# do_files [-t TAG]
function do_files() {
    if [ -z "$TAGNAME" ]; then
	cat "$list_file" | sed 's/@.*@//g' || return 1
    else
	cat "$list_file" | egrep "@${TAGNAME}@" | sed 's/@.*@//g' || return 2
    fi
    return 0
}

# do_remove $file
function do_remove() {
    # remove file record from file.list
    # I need sed...
    egrep "$1" "$list_file" > /dev/null
    if [ $? -eq 0 ]; then
    # remove backuped file from $VBAK_OUT_DIR
	file_bak_name=$(encode_file_name "$1")
	rm -rf "${VBAK_OUT_DIR}/${file_bak_name}"
	remove_line "$1";
    else
	die 1 "$1 not backuped!"
    fi
}

# do_update $file
function do_update() {
    # If the file is newer than the backuped file, 
    # then we will update it.
    egrep "$1" "$list_file" > /dev/null
    if [ $? -eq 0 ]; then
	file_bak_name=$(encode_file_name "$1")
	if [ "$1" -nt "${VBAK_OUT_DIR}/${file_bak_name}" ]; then
	    cp -rf "$1" "${VBAK_OUT_DIR}/${file_bak_name}"
	    echo -n "${1} "
	    echo -e ${blue}"*UPDATED!*"${clr_normal}
	fi
    else
	die 1 "${1} not backuped!"
    fi
}

# checkout a group of files with TAGNAME
function do_checkout() {
    egrep "@${TAGNAME}@" "$list_file" > /dev/null
    if [ $? -eq 0 ]; then
	tmp=$(mktemp /tmp/vbak.$RANDOM.XXXXXXX) || return 2
	egrep "@${TAGNAME}@" "$list_file" | sed 's/@.*@//g' > $tmp
	local let counter=0
	while read line
	do
	    file_bak_name=$(encode_file_name "$line")
	    file_base_name=$(basename "$line")
	    if [ -e "${VBAK_OUT_DIR}/${file_bak_name}" ]; then
		let ++counter
		cp -rf "${VBAK_OUT_DIR}/${file_bak_name}" "./$file_base_name"
	    else
		echo -n "${file_bak_name} "
		echo -e ${red}"*missed!*"${clr_normal}
	    fi
	done < $tmp
    else
	die 1 "No files checkouted!"
    fi
    echo "${counter} file(s) checkouted!"
}

# Empty the VBAK_OUT_DIR
# do_clear
function do_clear() {
    echo "We will remove all backuped files and clear up the file.list"
    echo -n "Are you sure? "
    read y_or_n
    if [ $y_or_n == "y" ]; then
	rm -rf $VBAK_OUT_DIR/*
    else
	return 1
    fi
    return 0
}

##### MAIN #####
if [ $# = 0 ]; then
    usage
fi

rcfile="$HOME/.vbakrc"
export rcfile
default_out_dir="$HOME/.vbak"

check_files $rcfile || die $? "Panic: I don't hope we will reach here."

VBAK_OUT_DIR=$(grep "VBAK_OUT_DIR" $rcfile | sed 's/^.*=//')
if [ -z "$VBAK_OUT_DIR" ]; then
    VBAK_OUT_DIR=$default_out_dir
fi

if ! echo $VBAK_OUT_DIR | egrep "^\/"; then
    VBAK_OUT_DIR="$HOME/$VBAK_OUT_DIR"
fi

export VBAK_OUT_DIR

if [ ! -d "$VBAK_OUT_DIR" ]; then
    mkdir -p "$VBAK_OUT_DIR"
fi

list_file="$VBAK_OUT_DIR/file.list"
check_files "$list_file"
export list_file

# Make error info more clearly.
red='\e[0;31;1m'
blue='\e[0;34;1m'
green='\e[0;32;1m'
clr_normal='\e[0m'

case "$1" in
    help)
	help_opt=$2
	show_help $2;
	;;
    list)
	shift
	get_tag_name "$@"
	do_list;
	;;
    files)
	shift
	get_tag_name "$@"
	do_files;
	;;
    add)
	shift
	get_tag_name "$@"
	# obmit the option and tag name
	if [ ! -z "$TAGNAME" ]; then
	    shift
	    shift
	fi
	for file in "$@"
	do
	    echo -n "Add "
	    echo -e ${green}"$file"${clr_normal}
	    do_add "$file";
	done
	;;
    remove)
	shift
	get_tag_name "$@"
	if [ ! -z "$TAGNAME" ]; then
	    tmp=$(mktemp "/tmp/vbak.$RANDOM.XXXXXXX") || return 2
	    egrep "@${TAGNAME}@" "$list_file" | sed 's/@.*@//g' > $tmp
	    while read line
	    do
		do_remove "$line";
	    done < $tmp
	else
	    for f in "$@"
	    do
		# full the file name
		full_name=$(full_file_name "$f")
		do_remove "$full_name";
	    done
	fi
	;;
    update)
	shift
	get_tag_name "$@"
	# vbak update OR vbak update -t TAGNAME
	if [[ ( -z "$1") || (! -z "$TAGNAME") ]]; then
	    tmp=$(mktemp "/tmp/vbak.$RANDOM.XXXXXXX") || return 2
	    if [ -z "$TAGNAME" ]; then
		sed 's/@.*@//g' "$list_file" > $tmp
	    else
		egrep "@${TAGNAME}@" "$list_file" | sed 's/@.*@//g' > $tmp
	    fi

	    while read line
	    do
		do_update "$line";
	    done < $tmp
	else
	    for f in "$@"
	    do
		# full the file name
		full_name=$(full_file_name "$f")
		do_update "$full_name";
	    done
	fi
	;;
    check|co)
	shift
	get_tag_name "$@"
	if [ -z "$TAGNAME" ]; then
	    die 1 "Don't leave checkout alone, give him '-t' and a tag name."
	fi
	do_checkout;
	;;
    clear)
	do_clear;
	;;
    *)
	echo "Unknown command!" >&2
	usage;;
esac
