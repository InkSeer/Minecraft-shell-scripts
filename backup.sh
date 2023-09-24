#!/bin/bash

# To make automated use a scheduler
discord_webhook="your webhook link"

if ! screen -list | grep -q "mc"; then
	# Notifi players of restart
	screen -r mc_console -X stuff 'say Server is restarting in 1 min (backup)'`echo -ne '\015'`
	sleep 1m

	screen -r mc_console -X stuff 'say Server is restarting'`echo -ne '\015'`
	sleep 5s

	# Shutting down server
	screen -S mc_console -X stuff 'stop'`echo -ne'\015'`
	curl -H "Content-Type: application/json" -d '{"embeds": [{"title": "Server is restatring (backup)","color": 11184810}]}' $discord_webhook
	sleep 10s

	# Check if server down
	if ! screen -list | grep -q "mc"; then
		# Server off
		# Variables for backup
		version=$(whoami)                    # Who created backup and/or version of minecraft
		name="world_server"                  # Name of world to backup
		backuppath="/minecraft/backup"       # Path for backup
		time=$(date +%F_%H-%M-%S)            # Date of backup, will be backup file name

		# Create backup dir
		mkdir -p "${backuppath}/${time}"
	
		# Check if backup dir exists
		if [[ "${backuppath}/${time}" != "" ]]; then
			# create backup 
			cp -r "${name}" "${backuppath}/${time}/${name}"

			# create version file
			echo "info" > "${backuppath}/${time}/${version}"
		else
			# backup dir (error)
			echo "Backup dir non-existent"
			exit 0
		fi
	
		sleep 1s
	
		# Check if backup exists
		if [[  -f "${backuppath}/${time}/${version}" ]]; then
			# Start server
			sh ./run.sh
			echo "Server is on and backup complete"
			exit 0
		else
			# Server off, backup not saved (error)
			echo "Server fail to start, world not saved"
			exit 0
		fi
	else
		# Server was not off (error)
		echo "Server is still on"
		exit 0
	fi
else 
	# Server was off (error)
 	echo "Server was off"
 	exit 0
fi
