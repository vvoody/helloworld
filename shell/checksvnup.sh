#!/bin/sh

cd /home/vvoody/lab/$1
current_branch=$(git branch | grep '*' | cut -d ' ' -f2)
if [ current_branch != "master" ]; then
	git checkout master
	if [ $? -ne 0 ]; then
		exit 1
	fi
fi

result=$(git svn rebase)
[ $? -ne 0 ] && git co $current_branch && exit 1
echo $result | grep 'Current branch master is up to date'

if [ $? -eq 0 ]; then
	echo $(date)" - $1 NO UPDATES" >> /tmp/vvchecksvnup
else
    msg="We got svn update! $1"
    [ -x $(which kdialog) ] && kdialog --title "Check svn update" --passivepopup "$msg" 60
	echo $(date)" - $1 GOT UPDATES" >> /tmp/vvchecksvnup
	echo "$result" >> /tmp/vvchecksvnup
fi

git checkout $current_branch
