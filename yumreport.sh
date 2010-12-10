#!/bin/bash

# crontab entry : 0 0 * * * /usr/local/scripts/yumreport.sh
# or softlink in cron.daily : ln -s /usr/local/scripts/yumreport.sh
# if there are updates for the server mail them to admin
#set -x

PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH

# location of binaries
#GREP=/bin/grep
#MAIL=/bin/mail
#YUM=/usr/bin/yum
#MKTEMP=/bin/mktemp
GREP=`which grep`
MAIL=`which mail`
YUM=`which yum`
MKTEMP=`which mktemp`

# mail address and servername
HOST=`hostname`
# fill in mail address
ADMIN=

if [ ! -f $YUM ]
        then
                echo "Cannot find $YUM"
        exit 1
fi

if [ ! -f $MKTEMP ]
        then
                echo "Cannot find $MKTEMP"
        exit 1
fi

if [ ! -f $MAIL ]
        then
                "echo Cannot find $MAIL"
        exit 1
fi

if [ ! -f $GREP ]
then
        echo "Cannot find $GREP"
        exit 1
fi

# dump the yum results to a safe working file
WORK=`$MKTEMP /tmp/yum.results.XXXXXX`
#$YUM check-update > $WORK
$YUM -e0 -d0 check-update > $WORK

# if there are updates available, mail them
if [ -s $WORK ]
then
        REPORT=`$MKTEMP /tmp/yum.report.XXXXXX`
        echo "==== The following updates are available for $HOST ===" > $REPORT
        cat $WORK >> $REPORT
#        cat $REPORT | mail -s "[SRVR:serverid] updates availabe for $HOST" $ADMIN
        cat $REPORT | mail -s "updates availabe for $HOST" $ADMIN
fi

# cleanup temp files
rm -f $REPORT $WORK


