#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This is a notifier program which sends email to admin when
# anybody logins to your remote machine via SSH.
#
# Requirements:
# - Python(of course);
# - API key of Mailgun service;
# - requests (Python HTTP library);
# - A remote machine like VPS;
#
# Usage:
# put following instructions to ~/.bash_profile (if you use bash):
#
#     if [ -r vps-login-notifier.py]; then
#         python vps-login-notifier.python ~/.vps-login-notifier.conf.json
#     fi
#
# Then you will receive an email when anybody logins to your site.
# The default log file is at /tmp/vps-login-notifier.log

import os
import sys
import time
import json
import logging
import requests


LOGFILE = '/tmp/vps-login-notifier.log'


def mail(sender, subject, body):

    return requests.post(
        sender["api_url"],
        auth=(sender["auth_user"], sender["api_key"]),
        data={"from": sender["from"],
              "to": sender["recipients"],
              "subject": subject,
              "text": body})


def get_ssh_login_info():
    return os.environ['SSH_CONNECTION'] if 'SSH_CONNECTION' in os.environ else 'No any ssh connection info found!'


if __name__ == "__main__":
    try:
        pid = os.fork()
        if pid > 0:
            print "Welcome aboard."
            sys.exit(0)
    except OSError, e:
        print >> sys.stderr, "fork #1 failed: %d (%s)" % (e.errno, e.strerror)
        sys.exit(1)

    logging.basicConfig(filename=LOGFILE,
                        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                        level=logging.INFO)
    logging.Formatter.converter = time.gmtime

    ssh_info = get_ssh_login_info()
    login_ip = ssh_info.split()[0]
    body = "%s\nhttp://whatismyipaddress.com/ip/%s" % (ssh_info, login_ip)

    with open(sys.argv[1]) as conf:
        sender = json.load(conf)
    r = mail(sender, 'VPS Login Notification', body)
    if r.status_code == 200:
        logging.info('login notification email sent OK.')
    else:
        print r.text
        logging.error(r.text)
