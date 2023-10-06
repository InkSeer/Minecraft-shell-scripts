#!/bin/bash

# Set up with a scheduler to regulary check 
# Only if you want server status in discord (can be removed)
discord_webhook_error="your webhook link"

# Check if server is running
if ! screen -list | grep -q "mc_console"; then
        # Server is not running
        echo "Server is not running"
        curl -H "Content-Type: application/json" -d '{"content": "Error 103: Server is not running."}' $discord_webhook_error
        exit 0
fi       
