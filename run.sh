#!/bin/bash

screen -dmS mc_console java -Xmx1024M -Xms2024M -jar minecraft_server.jar nogui

# Only if you want server status in discord (can be removed)
discord_webhook="your webhook link"
curl -H "Content-Type: application/json" -d '{"embeds": [{"title": "Server is on","color": 5635925}]}' $discord_webhook

