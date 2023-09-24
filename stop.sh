#!/bin/bash

screen -S mc_console -X stuff 'stop'`echo -ne'\015'`

# Only if you want server status in discord (can be removed)
discord_webhook="your webhook link"
curl -H "Content-Type: application/json" -d '{"embeds": [{"title": "Server is off","color": 16733525}]}' $discord_webhook
