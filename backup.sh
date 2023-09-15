#!/bin/bash

if ! screen -list | grep -q "mc"; then
	# notifi players of restart
	screen -r mc_console -X stuff 'say Server is restarting in 1 min (backup)'`echo -ne '\015'`
	sleep 1m

	screen -r mc_console -X stuff 'say Server is restarting'`echo -ne '\015'`
	sleep 5s

	# shutting down server
	sh ./stop.sh
	sleep 10s

	# Check if server down
	if ! screen -list | grep -q "mc"; then
		# Server off
		# variables for backup
		version=$(whoami) # who created backup
		name="world_server" # name of world to backup
		backuppath="/minecraft/backup"
		time=$(date +%F_%H-%M-%S)

		# create backup dir
		mkdir -p "${backuppath}/${time}"
	
		# check if backup dir exists
		if [[ "${backuppath}/${time}" != "" ]]; then
			# create backup 
			cp -r "${name}" "${backuppath}/${time}/${name}"

			# create version file
			echo "info" > "${backuppath}/${time}/${version}"
		else
			# backup dir error
			echo "Backup dir non-existent"
			exit 0
		fi
	
		sleep 1s
	
		# check if backup exists
		if [[  -f "${backuppath}/${time}/${version}" ]]; then
			# start server
			sh ./run.sh
			echo "Server is on and backup complete"
			exit 0
		else
			# Server off, backup error
			echo "Server fail to start, world not saved"
			exit 0
		fi
	else
		# Server not off error
		echo "Server is still on"
		exit 0
	fi
else 
	exit 0
fi
