#!/bin/sh
#
# Set the twitter api to your own one for Twitter Opera Widget.
# Support both old and new twitter widgets:
#   http://widgets.opera.com/widget/7206/
#   http://widgets.opera.com/widget/14501/
# by vvoody <wxj.g.sh{AT}gmail.com>

function usage()
{
    echo "Usage: optwgt_setapi.sh  API_ADDR  OPERA_TWITTER_WIDGET.wgt"
}

if [ $# != 2 ]; then
    usage
    exit 1
fi

# '$1' is api address, '$2' is opera twitter widget file name.

API=$(echo $1 | sed 's/\//\\\//g')
HST=$(echo $1 | sed 's/http:\/\///' | sed 's/\/.*//')
WGT=${2%.*}
CWD=$(pwd)
TMP=optwgt_tmpdir

# uncompress the opera wgt file
mkdir $TMP
unzip ${WGT}.wgt -d $TMP
cd $TMP

# replace the api
sed -i "/\/access/i\
\ \ \ \ \ \ <host>$HST</host>" config.xml
cd ${CWD}/${TMP}/script
sed -i "s/http[s]\?:\/\/twitter.com\//$API/" twitter-api.js

# repackage
cd ${CWD}/${TMP}
zip -r ${WGT}_newapi.wgt *
mv ${WGT}_newapi.wgt $CWD

# cleanup
cd $CWD
echo -n "Do you wanna remove the temporary directory?(y/n) "
read answer
if [ $answer = "y" ]; then
    rm -rf $TMP
fi

echo "Set to new api successfully!"
