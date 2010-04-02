#!/bin/bash

# xxx.sh opera-snapshot1.tar.gz opera-snapshot2.tar.bz2 ...
# http://bbs.operachina.com/posting.php?mode=edit&f=72&p=223715

if [ $# -eq 0 ]; then
    exit 1
fi

files=($@)
URL="http://bbs.operachina.com/posting.php?mode=edit&f=72&p=223715"

# Latest snapshot version
latest="$(echo $1 | cut -d '.' -f1).$(echo $1 | cut -d '.' -f2)"
echo $latest
USER=
PASSWD=
# STEP 0: fetch cookies
curl -L -s -c operachina.txt -d "autologin=on&username=${USER}&password=${PASSWD}&redirect=index.php&login=%E7%99%BB%E5%BD%95" "http://bbs.operachina.com/ucp.php?mode=login"

# STEP 1: upload files
curl -s -b operachina.txt "$URL" -o edit.html
form="$(perl formfind.pl < edit.html)"

_lastclick="$(echo "$form" | grep lastclick | cut -d '=' -f3 | cut -d' ' -f1)"
_attach_sig="on"
_creation_time="$_lastclick"
_form_token="$(echo "$form" | grep form_token | cut -d '=' -f3 | cut -d' ' -f1)"
_proxid="$#"
_add_file="添加文件"
_fileupload="$(i=1;for f in "$@"; do echo '-F "'"fileupload${i}=@$f"'"'; i=$[$i+1]; done)"

# curl -b operachina.txt \
#     -F "lastclick=$_lastclick" \
#     -F "attach_sig=$_attach_sig" \
#     -F "creation_time=$_creation_time" \
#     -F "form_token=$_form_token" \
#     $(echo -n $files) \
#     -F "proxid=$_proxid" \
#     -F "add_file=$_add_file" \
#     "http://bbs.operachina.com/posting.php?mode=edit&f=72&p=223715" \
#     -o addnewfiles.html

cmd='curl -b operachina.txt -F "lastclick='$_lastclick'"'' -F "'"attach_sig=$_attach_sig"'"'' -F "'"creation_time=$_creation_time"'"'' -F "'"form_token=$_form_token"'" '"$_fileupload"' -F "'"proxid=$_proxid"'"'' -F "'"add_file=$_add_file"'" "'"$URL"'" -o addnewfiles.html'
eval $cmd

# STEP 2: submit form
form="$(perl formfind.pl < addnewfiles.html)"
_subject="最新snapshot下载($latest)"
_message="Enjoy ;-)"
_lastclick="$(echo "$form" | grep lastclick | cut -d '=' -f3 | cut -d' ' -f1)"
_attach_sig="on"
_creation_time="$_lastclick"
_form_token="$(echo "$form" | grep form_token | cut -d '=' -f3 | cut -d' ' -f1)"
_proxid="$#"
_post="提交"
_attch_id=($(echo "$form" | grep attach_id | cut -d '=' -f3 | cut -d ' ' -f1))
_attachment_data="$(i=0;j=$[$#-1];for f in "$@"; do echo '-F "'"attachment_data[${i}][attach_id]=${_attch_id[$i]}"'"'; echo '-F "'"attachment_data[${i}][is_orphan]=0"'"'; echo '-F "'"attachment_data[${i}][real_filename]=${files[$j]}"'"'; i=$[$i+1]; j=$[$j-1]; done)"

# Need a rest?
sleep 5
cmd='curl -b operachina.txt -F "subject='"$_subject"'" -F "message='"$_message"'" -F "lastclick='$_lastclick'" -F "attach_sig='$_attach_sig'" -F "creation_time='$_creation_time'" -F "form_token='$_form_token'" '$_attachment_data' -F "proxid='$_proxid'" -F "post='$_post'" "'$URL'" -o sub.html'
eval $cmd
