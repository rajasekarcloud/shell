# Script to check oracle account password expiry.
# Trigger an alert if the password expires in 10 days.
# Fetch the expiry date using chage -l and conver that into epoch time.
# Convert current time to epoch time.
# Find the difference between and alert.

#!/bin/bash
mon=`chage -l  oracle | grep -w "Password expires" | awk '{print $4}'`;
dt=`chage -l  oracle | grep -w "Password expires" | awk '{print $5}' | cut -d, -f1`;
year=`chage -l  oracle | grep -w "Password expires" | awk '{print $6}' | cut -d, -f1`;

# Converting expiry date to epoch time.
expiry="$mon $dt $year";
expiry_dt_epoch=`echo $(($(date --utc --date "$expiry" +%s)/86400))`;
current_dt_epoch=`echo $(($(date --utc --date "$1" +%s)/86400))`;
days=`expr $expiry_dt_epoch - $current_dt_epoch`;
if [ $days -le 10 ]
then
        echo "Oracle password expires in `echo $days` Days";
        echo "Sending mail....";
fi
