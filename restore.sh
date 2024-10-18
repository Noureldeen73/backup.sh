#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Arguments error"
    exit 1
fi

SOURCE_DIR=$1
BACKUP_DIR=$2
DIRECTORIES=($(ls -dt "$BACKUP_DIR"/*/))

if [ ${#DIRECTORIES[@]} -eq 0 ]; then
    echo "No backups found"
    exit 0
fi

INDEX=0
rm -rf "$SOURCE_DIR"/*
cp -r "${DIRECTORIES[INDEX]}"/* "$SOURCE_DIR"
echo "Last backup has been restored."

while true; do
    echo "------------"
    echo "1) Restore to the most recent version prior to the current backup"
    echo "2) Move forward to the next available version"
    echo "3) Break"
    echo "------------"
    read -rp "Choose an option: " INPUT

    case $INPUT in
        1)  
		if [ $INDEX -lt $((${#DIRECTORIES[@]} - 1)) ]; then
                INDEX=$((INDEX+1))
                rm -rf "$SOURCE_DIR"/*
		cp -r "${DIRECTORIES[INDEX]}"/* "$SOURCE_DIR"
		echo "Restored to the most recent prior backup: ${DIRECTORIES[INDEX]}"
            else
                echo "No older backup available to restore."
            fi
            ;;
        2)  
            if [ $INDEX -gt 0 ]; then
                INDEX=$((INDEX-1))
                rm -rf "$SOURCE_DIR"/*
		cp -r "${DIRECTORIES[INDEX]}"/* "$SOURCE_DIR"
                echo "Restored to the next available version: ${DIRECTORIES[INDEX]}"
            else
                echo "No newer backup available to restore."
            fi
            ;;
        3)  
            exit 0
            ;;
        *)  
            echo "Invalid option. Please choose 1, 2, or 3."
            ;;
    esac
done
