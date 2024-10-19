#!/bin/bash

#Cheking if the arguments is valid
if [ $# != 4 ]; then
	echo Arguments error
	exit 1
fi

#Inserting the positional arguments into variables
BACKUP_FROM=$1
BACKUP_TO=$2
FREQUENCY=$3
NUM_OF_BACKUPS=$4

#Cheking if max backups needed is greater than 1
if [ $NUM_OF_BACKUPS -lt 1 ]; then

	echo Backups must be greater than one
	exit 0
fi

#Getting current date in the format needed
CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")

#Storing directory info into a document
ls -lR "$BACKUP_FROM" > "$BACKUP_TO/directory-info.last"

#Copying source directory into the backup directory
cp -r "$BACKUP_FROM" "$BACKUP_TO/$CURRENT_DATE"

#Incrementing the number of copies
COPIES=1

#Infinte loop to do regular checking
while true;do
	sleep $FREQUENCY
	
	#Getting current source directory info
	ls -lR "$BACKUP_FROM" > "$BACKUP_TO/directory-info.new"

	#Comparing between the current and the last backup one
	if ! cmp -s $BACKUP_TO/directory-info.new $BACKUP_TO/directory-info.last; then
		#If i can create more backupps without exceeding the limit
		if [ "$COPIES" -lt "$NUM_OF_BACKUPS" ]; then
			
			#Start backup process
			CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
			cp -r "$BACKUP_FROM" "$BACKUP_TO/$CURRENT_DATE"
			echo "Backup created at : "$BACKUP_TO/$CURRENT_DATE""
			COPIES=$((COPIES + 1))
		else

			#If i cant create search for oldest backup
			OLDEST_FOLDER=$(ls -dt "$BACKUP_TO"/*/ | tail -n 1)
			if [ -n "$OLDEST_FOLDER" ]; then

				#Remove oldest backup and start backup process
				rm -r "$OLDEST_FOLDER"
				CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
				cp -r "$BACKUP_FROM" "$BACKUP_TO/$CURRENT_DATE"
				echo "Backup created at : "$BACKUP_TO/$CURRENT_DATE""
			fi
		fi

		#Changing the last backup info for the new one
		cp $BACKUP_TO/directory-info.new $BACKUP_TO/directory-info.last
	fi
done
