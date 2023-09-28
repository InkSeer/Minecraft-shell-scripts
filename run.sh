#!/bin/bash

screen -dmS mc_console java -Xmx2048M -Xms2048M -jar minecraft_server.jar nogui

# Only if you want server status in discord (can be removed)
discord_webhook="your webhook link"
discord_webhook_error="your webhook link"

if screen -list | grep -q "mc"; then
        # Server has started
        curl -H "Content-Type: application/json" -d '{"embeds": [{"title": "Server is on","color": 5635925}]}' $discord_webhook
        exit 0
else
        # Server failed to start
        curl -H "Content-Type: application/json" -d '{"content": "Error 101: Server failed to start."}' $discord_webhook_error
        exit 0
fi        
