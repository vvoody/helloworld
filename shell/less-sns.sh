#!/bin/sh

# put it to crontab -e, every hour we have 10 minutes free to the SNS.
# 0 * * * *   less-sns.sh stop
# 10 * * * *  less-sns.sh start

LOG=/tmp/less-sns
SNS="# LESS SNS
127.0.0.1  twitter.com
127.0.0.1  www.v2ex.com
127.0.0.1  v2ex.appspot.com
127.0.0.1  www.renren.com
127.0.0.1  www.kaixin001.com
127.0.0.1  www.douban.com
127.0.0.1  t.sina.com.cn
127.0.0.1  www.weibo.com"

mylog()
{
	echo $(date) " - $1" >> $LOG
}

case "$1" in
	start)
		echo "$SNS" >> /etc/hosts
		mylog "no SNS now."
		;;
	stop)
		sed -i '/# LESS SNS/,//d' /etc/hosts && mylog "free for SNS now."
		;;
	*)
		mylog "wrong argument '$1'"
esac

