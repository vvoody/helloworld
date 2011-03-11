#!/bin/bash

#Find empty files which were not created today in current directory
# and sub-directory (1-Level) and delete them if they are not created today.

# $0 [-c name] [-d dir]

CREATE_VERIFICATION_FILE=False  # -c
FILENAME=
SEARCH_PATH=$(pwd)              # -d
NUMS=0
DELETED_FILES=()

usage()
{
    echo "xxxx.sh [-c name] [-d /full/path]"
}

# $1 -> file be judged
rm_empty_file_not_created_today()
{
    today=$(date +%Y-%m-%d)
    file_mtime_date=$(/bin/ls -l "$1" | cut -d ' ' -f6)
    file_size=$(/bin/ls -l "$1" | cut -d ' ' -f5)
    if [ "$file_mtime_date" != "$today" ] && [ "$file_size" = "0" ]; then
        file_name=$(basename "$1")
        file_dir=$(dirname "$1")
        file_mtime=$(stat -c "%y" "$1")
        DELETED_FILES[$NUMS]="${file_dir}, ${file_name}, ${file_mtime}"
        NUMS=$[$NUMS+1]
        rm -f "$1"
    fi
}

# $1 -> directory to search
do_search_by_myself()
{
    for f in *; do
        if [ -f "$f" ]; then
            rm_empty_file_not_created_today "${1}/${f}"
        elif [ -d "$f" ]; then
            for ff in "${f}"/*; do
                rm_empty_file_not_created_today "${1}/${ff}"
            done
        fi
    done
}

# $1 -> directory to search
do_search_by_find()
{
    today=$(date +%Y-%m-%d)
    for f in `find . -empty -and ! -newermt "$today"`; do
        fn="${1}/${f:2}"
        file_name=$(basename "$fn")
        file_dir=$(dirname "$fn")
        file_mtime=$(stat -c "%y" "$fn")
        DELETED_FILES[$NUMS]="${file_dir}, ${file_name}, ${file_mtime}"
        NUMS=$[$NUMS+1]
        rm -f "$fn"
    done
}

output_report()
{
    echo -ne 'Stop time:\t' && date
    echo
    echo "The number of deleted files:" $NUMS
    echo "Path, file name and creation date of deleted file."
    for f in "${DELETED_FILES[@]}"; do
        echo "$f"
    done
}

# set signal
trap output_report SIGINT EXIT

echo -ne 'Start time:\t' && date

while getopts "c:d:" opt; do
    case $opt in
        c)
            CREATE_VERIFICATION_FILE=True
            FILENAME="$OPTARG"
            ;;
        d)
            SEARCH_PATH="$OPTARG"
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [ "$CREATE_VERIFICATION_FILE" = "True" ]; then
    touch "${SEARCH_PATH}/${FILENAME}"
    exit 0
fi

#do_search_by_myself "$SEARCH_PATH"
do_search_by_find "$SEARCH_PATH"
