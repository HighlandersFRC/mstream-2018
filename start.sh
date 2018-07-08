#!/bin/sh

#set -x
for i in 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 
do
    more=0
    for j in 0 1 2
    do
        rc=$(/home/pi/mjpg-streamer.sh status ${j} | grep Running)
        if [ -z "${rc}" ]; then
            /home/pi/mjpg-streamer.sh start ${j}
            more=1
        fi
    done

    if [ "${more}" -eq "0" ]; then
        exit 0
    fi
    sleep ${i}
done
