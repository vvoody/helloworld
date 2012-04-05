#!/bin/sh

# a script for the sake of your health
# when you login to desktop, this script will create an hourly
# job for you. After one hour, it will notify you to stand up.
# put one line in your ~/.xinitrc file if use startx,
#                      ~/.kde/Autostart/foo.sh if use KDE,
#                      ??? if use ???:
# bash /path/to/stand_up_every_hour.sh

ICON=/tmp/icon
CRON_FLAG="# stand_up_every_hour"
THIS_SCRIPT=$0
EXPIRE_TIME=300000  # milliseconds

if [ "${THIS_SCRIPT:0:1}" != "/" ]; then
    THIS_SCRIPT=$(pwd)/$0
fi

# only be executed once when user login
# set crontab according to current time, Nth minute of an hour
set_crontab() {
    tmpf=/tmp/$RANDOM
    crontab -l | sed "/^$CRON_FLAG/,+1d" > $tmpf
    echo "$CRON_FLAG" >> $tmpf
    echo $(date +%M) '* * * *' 'DISPLAY=:0.0 ' "bash $THIS_SCRIPT" >> $tmpf
    crontab $tmpf
    rm -f $tmpf
}

# extract icon file attached in this script file
# notify-send doesn't support "-i -", so have to output to an external file
decode_icon() {
    match=$(grep --text --line-number '^PAYLOAD:$' $THIS_SCRIPT | cut -d ':' -f 1)
    payload_start=$((match + 1))
    tail -n +$payload_start $THIS_SCRIPT | uudecode -o $ICON
}

#
trigger_notify() {
    decode_icon
    notify-send -i $ICON -t $EXPIRE_TIME "STAND UP!"
}

case "$1" in
    --set-crontab)
        set_crontab
        echo "Here is your new crontab:"
        crontab -l
        ;;
    '')
        trigger_notify
        echo "Do you see the notify?"
        ;;
    *)
        echo "NONSENSE!"
        echo "bash $0 [--set-crontab]" && exit 1
        ;;
esac
exit 0

# NO EDIT FROM HERE!
PATLOAD:
begin 644 icon.png
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
9`8```P"3`F\<TZ,.90````!)14Y$KD)@@@``
`
end
