#!/bin/bash

# Convert the ape/flac files(splited) to mp3 format.
# 01.a.flac, 02.xy.flac,... -> 01.a.mp3, 02.xy.mp3, ...
#
# ;-) vvoody <wxj.g.sh{at}gmail.com>

if [ "$1" == "--help" ]; then
    echo "Usage: $0 your.cue orig_format"
    exit 1
fi

cuefile=$1
ext=$2

count=1
for f in *.${ext}; do
    artist=$(cueprint -n$count -t '%p' "$cuefile")
    album=$(cueprint -n$count -t '%T' "$cuefile")
    tracknum=$(cueprint -n$count -t '%02n' "$cuefile")
    title=$(cueprint -n$count -t '%t' "$cuefile")
    
    shntool conv -i $ext -o 'cust ext=mp3 lame -b 192 - %f' "$f"
    
    mp3file="$(basename "$f" .$ext).mp3"
    echo "$mp3file"
    mid3v2 --artist="$artist" --album="$ablum" --track="$tracknum" \
	--song="$title" "$mp3file"

    count=$[$count + 1]
done
