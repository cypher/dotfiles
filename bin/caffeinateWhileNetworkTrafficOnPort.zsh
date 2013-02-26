#!/bin/zsh
#
#       keeps your computer awake (macos x 10.8) when a network port is only used
#       from time to time (e.g. AirVideo). Requires root privileges ;-(
#
#       Place this script where it stays around and start it as root once.
#
#       It will create a launchd entry which will stay around after reboots
#

launchdname=de.jinx.caffeinateWhileNetworkTrafficOnPort
port=45631
timetokeepawake=300
interleavetime=200


if [[ $1 != $launchdname ]];
then
    programpath=$PWD/`basename $0`
    launchdplistpath=/Library/LaunchDaemons/$launchdname.plist

    cat >$launchdplistpath <<EOF
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC -//Apple Computer//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd >
<plist version="1.0"><dict>
<key>Label</key>
<string>$launchdname</string>
<key>ProgramArguments</key>
<array>
<string>$programpath</string>
<string>$launchdname</string>
</array>
<key>KeepAlive</key><true/></dict></plist>
EOF
    launchctl remove $launchdname >/dev/null 2>&1
    launchctl load -w $launchdplistpath
    exit
fi

while 1=1
do
    /usr/sbin/tcpdump -n -c 1 -i en0 -s0 src port $port and tcp >/dev/null 2>/dev/null
    /usr/bin/caffeinate -t $timetokeepawake &
    sleep $interleavetime
done

