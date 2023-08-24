#!/usr/bin/env bash
# This script restores the lazy-lock.json file
# to the last from the backup folder

# Get the backup directory
backup_dir="$HOME/.config/nvim/lockfiles"
# Check if the directory exists
if [ ! -d "$backup_dir" ]; then
	echo "The backup directory $backup_dir does not exist!"
fi

# Get the last modified file
newest_file=$(find "$backup_dir" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d' ')

if [ -f "$newest_file" ]; then
	# Prompt the user to confirm before restoring the backup file
	read -rp "Are you sure you want to restore $newest_file? (y/n) " choice
	case "$choice" in
	y | Y)
		echo "Restoring $newest_file..."
		rm lazy-lock.json
		echo "Removed the current lazy-lock.json file!"
		cp "$newest_file" .
		mv "$(basename "$newest_file")" lazy-lock.json
		echo "Restored the backup file!"
		;;
	n | N)
		echo "Aborted restore operation."
		;;
	*)
		echo "Invalid choice. Aborted restore operation."
		;;
	esac
else
	echo "No backup files found!"
	echo "Perhaps you could use git reset"
fi
