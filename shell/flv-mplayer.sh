#!/bin/bash
# View the flv video via MPlayer in Opera.
# http://bbs.operachina.com/viewtopic.php?f=30&t=33649
# by vvoody <wxj.g.sh{AT}gmail.com ;-)
# 
# ChangeLog
# 2010-02-17 support SMPlayer
# 2008-09-12 1.1 Reparse the flv urls, fix the multi-flv list.
#

flv_web_addr=$1

wget -O /tmp/flv-search-result.txt http://www.flvcd.com/parse.php?kw=$1

grep "<U>" /tmp/flv-search-result.txt | sed s/\<U\>//g > /tmp/flv.list

smplayer -add-to-playlist $(cat /tmp/flv.list | tr '\n' ' ')

rm -f /tmp/flv-search-result.txt /tmp/flv.list
