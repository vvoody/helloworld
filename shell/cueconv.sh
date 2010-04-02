#!/bin/bash

# Split the big single ape/flac file to mp3 or ogg files.
# Lastly, write the id3(version 2) tag info into the mp3s or oggs.
#
# It will try to detect the encoding of the cue sheet with 'file' 
# and convert it into UTF-8 encoding. But don't relay on it so much.
#
# Required: mac, flac, lame, cuetools, id3v2, shntool, vorbis-tools
#
# Edited from Brian Archive CUE/FLAC Splitter v0.1
# ;-) vvoody <wxj.g.sh{at}gmail.com>
#  ;) Grissiom <chaos.proton{at}gmail.com>

echo_usage()
{
	echo
	echo "usage: " $(basename $0) " [option] [encoding_type [encoding_options]] <cuefile> [flac_or_ape_file]"
	echo 
	echo "option:"
	echo "    -q: be quiet"
	echo
	echo "encoding_type:"
	echo "    mp3: split sndfile into mp3 files.(default)"
	echo "    ogg: split sndfile into ogg files."
	echo
	echo "encoding_options: options pass to the encoder,"
	echo "                  must enclosed in quotation marks"
	echo
	echo "If you want to specify the encoding options, you must specify the encoding type."
	echo "We use lame for mp3 encoding and oggenc(provided by vorbis-tools) for ogg ones."
	echo
	echo "If your locale is not UTF-8, please define the flac/ape file name followed the <cuefile>."
	echo
}

# make the world more colorful ;)
# I currently use
# yellow for progress messages and
# blue   for info messages and
# green  for Done messages and
# red    for the lovely face in the end ;-)
# We may use red for error messages but 
# it has not implemented yet...
red='\e[0;31;1m'
green='\e[0;32;1m'
yellow='\e[0;33;1m'
blue='\e[0;34;1m'
clr_normal='\e[0m'

# work around for issue1&2
if ! locale | egrep -q "^LC_CTYPE.*(UTF|utf)-8(\")?$"; then
	echo -e ${red}"Your locale is not UTF-8, "
	echo -e "Be sure to define the flac/ape file name followed the <cuefile>."${clr_normal}
fi

# make sure we have write permission in the PWD
PWD=$(pwd)
if [ ! -w "$PWD" ]; then
	echo -e ${red}"I don't have write permission in ${PWD} ."${clr_normal}
	exit 1
fi

######################################################
# parameter parse begin
######################################################

sndfile_flag=0
if [[ $1 = "--help" ]]; then
	echo_usage
	exit 0
fi

if [[ $1 = "-q" ]]; then
	quiet=1
	shift
else
	quiet=0
fi

# -V2 is the recommended option for lame.(you can see it by typing lame --help)
case $# in
	1 )
	cuefile="$1"
	ext="mp3"
	enopt="-V2"
	;;
	2 )
	ext=$1
	if [[ $ext = "mp3" ]]; then
		enopt="-V2"
	fi
	cuefile="$2"
	;;
	3 )
	ext=$1
	enopt="$2"
	cuefile="$3"
	;;
	4 )
	ext=$1
	enopt="$2"
	cuefile="$3"
	sndfile="$4"
	sndfile_flag=1
	;;
	* )
	echo_usage
	exit 1
	;;
esac

case $ext in
	"mp3" )
	encmd="cust ext=mp3 lame $enopt - %f"
	;;
	"ogg" )
	encmd="cust ext=ogg oggenc $enopt - -o %f"
	;;
	* )
	echo_usage
	exit 1
esac

######################################################
# parameter parse finished, we can begin the work now ;)
######################################################
if [ ! -r "$cuefile" ]; then
	echo_usage
	echo -e ${red}"cuesheet ${cuefile} not found or I don't have read permission!"${clr_normal}
	exit 1
fi

# Changed following line, see Issues No.6
if file "$cuefile" | egrep -q 'UTF-8'; then
	rm_ufile=0
else
	iconv -f GB18030 -t UTF-8 "$cuefile" -o "${cuefile}-u.cue"
	cuefile="${cuefile}-u.cue"
	rm_ufile=1
fi

echo -e ${yellow}"extract info from the cue file..."${clr_normal}

if [ $sndfile_flag -eq 0 ]; then
	sndfile=$(egrep '^FILE' "$cuefile" | awk -F'"' '{print $2}')
	# According to http://digitalx.org/cuesheetsyntax.php ,
	# the file name may not be enclosed  in quotation marks.
	if [ -z "$sndfile" ]; then
		sndfile=$(egrep '^FILE' "$cuefile" | awk -F' ' '{print $2}')
	fi
fi
if [ ! -r "$sndfile" ]; then
	echo -e ${red}"CD image ${sndfile} not found or I don't have read permission!"${clr_normal}
	exit 1
fi

tracks=$(cueprint -d '%N' "$cuefile")
echo -e ${blue}${tracks}" tracks altogether."${clr_normal}

genre=$(cueprint -d '%G' "$cuefile")
# many cue sheets put the genre and date info into REM section(the comment section),
# we can grab the info in this way.
if [ -z $genre ]; then
	genre=$(egrep '^REM GENRE ' "$cuefile" | cut -c 11-)
fi
# cueprint can't grap date info in cue sheets...
date=$(egrep '^REM DATE ' "$cuefile" | cut -c 10-)

# extract comments
comments=$(egrep '^REM ' "$cuefile" | sed -e '/^REM GENRE/d; /^REM DATE/d; s/REM //; s/ /=/')

# Store the idv3 info. We will write them to the mp3s later.
id3count=1
if [ $quiet -eq 0 ]; then
	echo "Disk Genre: "$genre
	echo
fi
while [ $id3count -le $tracks ]; do
	artist[$id3count]=$(cueprint -n$id3count -t '%p' "$cuefile")
	album[$id3count]=$(cueprint -n$id3count -t '%T' "$cuefile")
	tracknum[$id3count]=$(cueprint -n$id3count -t '%02n' "$cuefile")
	title[$id3count]=$(cueprint -n$id3count -t '%t' "$cuefile")
	if [ $quiet -eq 0 ]; then
		echo "Artist      - ${artist[$id3count]}"
		echo "Album       - ${album[$id3count]}"
		echo "Track No.   - ${tracknum[$id3count]}"
		echo "Track Title - ${title[$id3count]}"
		echo
	fi
	id3count=$[$id3count + 1]
done

echo -e ${green}"Done."${clr_normal}

if [ $quiet -eq 0 ]; then
	echo "=================================================="
fi
# Split and convert the single ape/flac file.
# Each mp3 name is like: "07.Yesterday Once More.mp3"
# More output format, see man shntool
# \:*?"<>|/ are invalid filename characters in DOS,
# / is invalid filename character in UNIX. So convert them or we couldn't split the file.
echo -e ${yellow}"split and convert ${blue}$sndfile"${clr_normal}
echo -e ${yellow}"into ${blue}$ext ${yellow}files"${clr_normal}
shntool split -f "$cuefile" -t '%n.%t' -m '\-:-*x?-"-/_<->-|-' -o "$encmd" "$sndfile"

# Remove the pregrap file, or it will make write the id3 incorrectly.
if [ -f "00.pregap."$ext ]; then
	rm -f 00.pregap.$ext
	if [ $quiet -eq 0 ]; then
		echo "00.pregap.$ext found! Removed it."
	fi
fi

echo -e ${yellow}"tag the files..."${clr_normal}
# Write the id3v2 into the output files.
# Either mid3v2 or id3tag will corrupt ogg files...
# And it seems that ogg files have a different type of tagging.
acount=1
for outfile in *.$ext; do
	if [ $quiet -eq 0 ]; then
		echo "=================================================="
		echo "tagging ${outfile}:"
		echo "Artist      - ${artist[$acount]}"
		echo "Album       - ${album[acount]}"
		echo "Track No.   - ${tracknum[acount]}"
		echo "Total track - ${tracks}"
		echo "Track Title - ${title[acount]}"
		echo "Genre       - ${genre}"
		echo "Date        - ${date}"
		echo 
	fi
	if [ $ext = 'mp3' ]; then
		mid3v2 \
		--artist="${artist[$acount]}" \
		--album="${album[acount]}" \
		--track="${tracknum[acount]}" \
		--song="${title[acount]}" \
		--genre="${genre}" \
		--year="${date}" \
		"$outfile"
		#id3tag 1>/dev/null \
		#--artist="${artist[$acount]}" \
		#--album="${album[acount]}" \
		#--track="${tracknum[acount]}" \
		#--song="${title[acount]}" \
		#--total="${tracks}" \
		#--genre="${genre}" \
		#--year="${date}" \
		#"$outfile"
	elif [ $ext = 'ogg' ]; then
		cat <<-EOF 2>/dev/null | vorbiscomment -a "$outfile" 1>/dev/null
		artist=${artist[$acount]}
		album=${album[acount]}
		title=${title[acount]}
		genre=${genre}
		totaltracks=${tracks}
		tracknumber=${tracknum[acount]}
		date=${date}
		$comments
		EOF
	fi
	acount=$[$acount + 1]
done

echo -e ${green}"Done. Enjoy your music. ;${yellow}-${red})"${clr_normal}
if [ $rm_ufile -eq 1 ]; then
	rm "$cuefile"
fi

# End of script.
