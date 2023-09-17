#!/bin/bash

screen -S mc_console -X stuff 'stop'`echo -ne'\015'`

# Only if you want server status in discord (can be removed)
discord_webhook="your webhook link"

curl -H "Content-Type: application/json" -d '{"username": "Server", "content": "Server is off"}' $discord_webhook
