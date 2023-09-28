#!/bin/bash

screen -S mc_console -X stuff 'stop'`echo -ne'\015'`

# Only if you want server status in discord (can be removed)
discord_webhook="your webhook link"
discord_webhook_error="your webhook link"

if ! screen -list | grep -q "mc"; then
        # Server has stopped
        curl -H "Content-Type: application/json" -d '{"embeds": [{"title": "Server is off","color": 16733525}]}' $discord_webhook
        exit 0
else
        # Server failed to stop
        curl -H "Content-Type: application/json" -d '{"content": "Error 102: Server failed to start"}' $discord_webhook_error
        exit 0
fi
