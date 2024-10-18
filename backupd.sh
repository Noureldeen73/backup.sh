#!/bin/bash

cleanup() {
    echo "Backup process interrupted. Exiting..."
    exit 0
}

trap cleanup SIGINT

if [ $# != 4 ]; then
	echo Arguments error
	exit 1
fi

BACKUP_FROM=$1
BACKUP_TO=$2
FREQUENCY=$3
NUM_OF_BACKUPS=$4

if [ $NUM_OF_BACKUPS -lt 1 ]; then

	echo Backups must be greater than one
	exit 0
fi


CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
ls -lR "$BACKUP_FROM" > "$BACKUP_TO/directory-info.last"
cp -r "$BACKUP_FROM" "$BACKUP_TO/$CURRENT_DATE"
COPIES=1

while true;do
	sleep $FREQUENCY
	ls -lR "$BACKUP_FROM" > "$BACKUP_TO/directory-info.new"
	if ! cmp -s $BACKUP_TO/directory-info.new $BACKUP_TO/directory-info.last; then
		if [ "$COPIES" -lt "$NUM_OF_BACKUPS" ]; then
			CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
			cp -r "$BACKUP_FROM" "$BACKUP_TO/$CURRENT_DATE"
			echo "Backup created at : "$BACKUP_TO/$CURRENT_DATE""
			COPIES=$((COPIES + 1))
		else
			OLDEST_FOLDER=$(ls -dt "$BACKUP_TO"/*/ | tail -n 1)
			if [ -n "$OLDEST_FOLDER" ]; then
				rm -r "$OLDEST_FOLDER"
				CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
				cp -r "$BACKUP_FROM" "$BACKUP_TO/$CURRENT_DATE"
				echo "Backup created at : "$BACKUP_TO/$CURRENT_DATE""
			fi
		fi
		cp $BACKUP_TO/directory-info.new $BACKUP_TO/directory-info.last
	fi
done
