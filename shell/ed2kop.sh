#!/bin/sh

# A script for adding ed2k links to MLdonkey from Opera browser.
# Based on 'mldonkey_command'
# To run this program, you need the nc (netcat) program
# by vvoody - visit http://bbs.operachina.com/viewforum.php?f=72 for more.

MLDONKEY_IP=127.0.0.1
MLDONKEY_PORT=4000

# MLdonkey's default user is 'admin', no passwd.
# If you do not set passwd, leave them empty.
MLUSER=
MLPASSWD=

if [ ! -z $MLUSER ]; then
    $AUTH_INFO="auth $MLUSER $MLPASSWD"
fi

nc $MLDONKEY_IP $MLDONKEY_PORT <<EOF
$AUTH_INFO
dllink '$1'
q
EOF
