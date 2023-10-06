#!/bin/bash

# To make automated use a scheduler
discord_webhook="your webhook link"
discord_webhook_error="your webhook link"

# Check if server is on
if screen -list | grep -q "mc_console"; then
	# Server is on
	# Notifi players of restart
	screen -r mc_console -X stuff "say Server is restarting in 1 min (backup)^M"
	sleep 1m
	screen -r mc_console -X stuff "say Server is restarting^M"
	sleep 5s

	# Shutting down server
	screen -S mc_console -X stuff "stop^M"
	curl -H "Content-Type: application/json" -d '{"embeds": [{"title": "Server is restatring (backup)","color": 11184810}]}' $discord_webhook
	sleep 10s

	# Check if server is down
	if ! screen -list | grep -q "mc_console"; then
		# Server off
		# Variables for backup
		version=$(whoami)                    # Who created backup and/or version of minecraft
		name="world_server"                  # Name of world to backup
		backuppath="/minecraft/backup"       # Path for backup
		time=$(date +%F_%H-%M-%S)            # Date of backup, will be backup file name

		# Create backup dir
		mkdir -p "${backuppath}/${time}"
	
		# Check if backup dir exists
		if [ -d "${backuppath}/${time}" ]; then
			# create backup 
			cp -r "${name}" "${backuppath}/${time}/${name}"

			# create version file
			echo "info" > "${backuppath}/${time}/${version}"
		else
			# backup dir (error 125)
			echo "Backup dir non-existent"
  			curl -H "Content-Type: application/json" -d '{"content": "Error 125: Backup directory for the backup does not exist."}' $discord_webhook_error
			exit 0
		fi
	
		sleep 1s
	
		# Check if backup exists
		if [ -f "${backuppath}/${time}/${version}" ]; then
			# Start server
			source "$(pwd)/run.sh"

   			# Check if server start
   			if screen -list | grep -q "mc_console"; then
      				# Completed backup with succesful server start
			       	echo "Server is on and backup complete"
				exit 0
    			else
       				# Completed backup with failed server start (error 124)
	   			echo "Server is off and backup complete"
	   			curl -H "Content-Type: application/json" -d '{"content": "Error 124: Server failed to start after backup was completed."}' $discord_webhook_error
				exit 0
      			fi
		else
			# Server off, backup not saved (error 123)
			echo "Server fail to start, world not saved"
  			curl -H "Content-Type: application/json" -d '{"content": "Error 123: Backup was not completed and server has not started."}' $discord_webhook_error
			exit 0
		fi
	else
		# Server was not off (error 122)
		echo "Server is still on"
  		curl -H "Content-Type: application/json" -d '{"content": "Error 122: Server failed to shut down for the backup."}' $discord_webhook_error
  		exit 0
	fi
else 
	# Server was off (error 121)
 	echo "Server was off"
  	curl -H "Content-Type: application/json" -d '{"content": "Error 121: Server was of when trying to create thebackup."}' $discord_webhook_error
 	exit 0
fi
