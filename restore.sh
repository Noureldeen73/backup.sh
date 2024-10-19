#!/bin/bash

#Checking if argumennts valid
if [ $# -ne 2 ]; then
    echo "Arguments error"
    exit 1
fi

#Inserting positional arguments in variables
SOURCE_DIR=$1
BACKUP_DIR=$2
DIRECTORIES=($(ls -dt "$BACKUP_DIR"/*/))

#Checking if existsalready backups
if [ ${#DIRECTORIES[@]} -eq 0 ]; then
    echo "No backups found"
    exit 0
fi

#Indexing most recent backup
INDEX=0

#Restoring to the most recent backup
rm -rf "$SOURCE_DIR"/*
cp -r "${DIRECTORIES[INDEX]}"/* "$SOURCE_DIR"
echo "Latest backup has been restored."

#Infinte loop taking input from user for what the user want
while true; do
    echo "------------"
    echo "1) Restore to the most recent version prior to the current backup"
    echo "2) Move forward to the next available version"
    echo "3) Break"
    echo "------------"
    read -rp "Choose an option: " INPUT

    case $INPUT in
        1)  
		#Cheking if ther is older backups
	        if [ $INDEX -lt $((${#DIRECTORIES[@]} - 1)) ]; then
			#If exists restore to it
                        INDEX=$((INDEX+1))
                        rm -rf "$SOURCE_DIR"/*
		        cp -r "${DIRECTORIES[INDEX]}"/* "$SOURCE_DIR"
	 	        echo "Restored to the most recent prior backup: ${DIRECTORIES[INDEX]}"
                else
			#Print if not exist
                        echo "No older backup available to restore."
                fi
                ;;
        2)
		#Cheking if there is newer backups
                if [ $INDEX -gt 0 ]; then
			#If exists restore to it
                        INDEX=$((INDEX-1))
                        rm -rf "$SOURCE_DIR"/*
		        cp -r "${DIRECTORIES[INDEX]}"/* "$SOURCE_DIR"
                        echo "Restored to the next available version: ${DIRECTORIES[INDEX]}"
                else
			#Print if not exist
                        echo "No newer backup available to restore."
                fi
                ;;
        3)
		#Exiting
                exit 0
                ;;
        *)
		#Handling unknown inputs
                echo "Invalid option. Please choose 1, 2, or 3."
                ;;
    esac
done
