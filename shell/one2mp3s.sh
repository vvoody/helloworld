#!/bin/bash

# Split the big single ape/flac file and then convert to mp3 format.
# Lastly, write the id3(version 2) tag info into the mp3s.
# 
# Ensure that your cue file is *UTF-8* encoding. NO GB* id3!
#
# Required: mac, flac, lame, cuetools, mutagen, shntool
#
# Edited from Brian's Archive CUE/FLAC Splitter v0.1
# ;-) vvoody <wxj.g.sh{at}gmail.com>


if [ "$1" == "--help" ]; then
    echo "======================================="
    echo " Usage: $0 your.ape|flac your.cue" 1>&2
    echo "======================================="
    exit 0
fi

if [ $# -lt 2 ]; then
    echo "======================================="
    echo " Usage: $0 your.ape|flac your.cue" 1>&2
    echo "======================================="
    exit 1
fi

hifile=$1 # .ape or .flac lossless audio file
cuefile=$2

tracks=$(cueprint -d '%N' "$cuefile")

# Store the idv3 info. We will write them to the mp3s later.
id3count=1
while [ $id3count -le $tracks ]; do
    artist[$id3count]=$(cueprint -n$id3count -t '%p' "$cuefile")
    album[$id3count]=$(cueprint -n$id3count -t '%T' "$cuefile")
    tracknum[$id3count]=$(cueprint -n$id3count -t '%02n' "$cuefile")
    title[$id3count]=$(cueprint -n$id3count -t '%t' "$cuefile")
    echo "Artist      - ${artist[$id3count]}"
    echo "Album       - ${album[$id3count]}"
    echo "Track No.   - ${tracknum[$id3count]}"
    echo "Track Title - ${title[$id3count]}"
    echo
    id3count=$[$id3count + 1]
done

echo "=================================================="

# Split and convert the single ape/flac file.
# Each mp3's name is like: "07.Yesterday Once More.mp3"
# Default bit rate is 128, you can customize it by using -b option.
# More output format, see `man shntool`
shntool split -f "$cuefile" -t '%n.%t' -o 'cust ext=mp3 lame -b 320 - %f' "$hifile"

# Remove the pregrap file, or it will make write the id3 incorrectly.
if [ -f "00.pregap.mp3" ]; then
    rm -f 00.pregap.mp3
    echo "00.pregap.mp3 found! Removed it."
fi

# Write the id3v2 into the mp3 files.
acount=1
for mp3file in *.mp3; do
    mid3v2 --artist="${artist[$acount]}" --album="${album[acount]}" --track="${tracknum[acount]}" \
	--song="${title[acount]}" "$mp3file"
    acount=$[$acount + 1]
done

# End of script.
