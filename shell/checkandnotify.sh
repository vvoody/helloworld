#!/bin/sh

cd /home/vvoody/lab/backend-2.6.1_git/
git svn rebase | grep 'Current branch master is up to date.'
if [ $? -eq 0 ]; then
	echo $(date) ' - NO UPDATES' >> /tmp/vvchecksvnup
else
    msg="We got svn update!"
    [ -x $(which kdialog) ] && kdialog --title "Check svn update" --passivepopup "$msg" 60
	echo $(date) ' - GOT UPDATES' >> /tmp/vvchecksvnup
fi