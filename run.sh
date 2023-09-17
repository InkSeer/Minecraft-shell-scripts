#!/bin/bash

screen -dmS mc_console java -Xmx1024M -Xms2024M -jar minecraft_server.jar nogui

discord_webhook="your webhook link"

curl -H "Content-Type: application/json" -d '{"username": "Server", "content": "Server is on"}' $discord_webhook

