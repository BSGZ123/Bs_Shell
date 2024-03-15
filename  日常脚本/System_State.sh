#! /usr/bin/env bash
# 系统状态（CPU，内存）

OUTFILE=/home/results/capstats.csv
DATE=$(date +%m/%d/%Y)
TIME=$(date +%k:%m:%s)
TIMEOUT=$(uptime)
VMOUT=$(vmstat 1 2)
USERS=$(echo "$TIMEOUT" | gawk '{print $4}')
# gawk 'match($0, /load average: ([0-9.]+), ([0-9.]+), ([0-9.]+)/, arr) {print arr[1], arr[2], arr[3]}'
LOAD=$(echo "$TIMEOUT" | gawk 'match($0, /load average: ([0-9.]+), ([0-9.]+), ([0-9.]+)/, arr) {print arr[1], arr[2], arr[3]}' | sed "s/,//")
FREE=$(echo "$VMOUT" | sed -n '/[0-9]/p' | sed -n '2p' | gawk '{print $4}')
IDLE=$(echo  "$VMOUT" | sed -n '/[0-9]/p' | sed -n '2p' |gawk '{print $15}')
echo "$DATE,$TIME,$USERS,$LOAD,$FREE,$IDLE" >> $OUTFILE
