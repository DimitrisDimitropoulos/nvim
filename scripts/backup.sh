#!/usr/bin/env bash
# This script is used to backup the lazy-lock.json files
# i.e. it takes the into the lockfiles folder and
# renames them based on the date

# Set the backup directory
backup_dir="$HOME/.config/nvim/lockfiles"

# Check if the directory exists
if [ ! -d "$backup_dir" ]; then
	echo "The backup directory $backup_dir does not exist!"
fi

# Get the current date and time
date=$(date +"%d-%m-%Y-%H-%M-%S")

# Check if the file exists and is not a directory
if [ -f "lazy-lock.json" ]; then
	cp lazy-lock.json "$backup_dir/"
	mv "$backup_dir/lazy-lock.json" "$backup_dir/$date-lazy-lock.json"
	echo "Backup of lazy-lock.json completed!"
	echo "The name of your backup file is $date-lazy-lock.json"
	echo "It follows day-month-year-hour-minute-second format"
else
	echo "lazy-lock.json does not exist!"
fi
