#!/bin/bash

set -e

SRC_DIR=/home
BACKUP_DIR=/backup/backups
EXCLUSIONS_FILE=$1

if [ -z "$EXCLUSIONS_FILE" ]
then
	echo "usage: inter-drive exclusionslist.txt"
	echo "backup FAILED"
	exit 1
fi

if [ ! -e $EXCLUSIONS_FILE ]
then
	echo "exclusions file $EXCLUSIONS_FILE doesn't exist"
	echo "backup FAILED"
	exit 1
fi

if [ ! -d $SRC_DIR ]
then
	echo "$SRC_DIR doesn't exist"
	echo "backup FAILED"
	exit 1
fi

if [ ! -d $BACKUP_DIR ]
then
	echo "$BACKUP_DIR doesn't exist"
	echo "backup FAILED"
	exit 1
fi

DAILY="$BACKUP_DIR/$(date +%A).tar"
MONTHLY="$BACKUP_DIR/$(date +%B).tar"

date > "$DAILY.log"
echo "creating daily backup $DAILY"
tar cvfp $DAILY --exclude-from $EXCLUSIONS_FILE $SRC_DIR >> "$DAILY.log"
date >> "$DAILY.log"
echo "backup COMPLETE" >> "$DAILY.log"

echo "creating monthly backup $MONTHLY"
cp -f $DAILY $MONTHLY
cp -f "$DAILY.log" "$MONTHLY.log"
date >> "$MONTHLY.log"
echo "backup COMPLETE" >> "$MONTHLY.log"

exit 0
