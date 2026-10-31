#!/bin/bash
# Installs the Get Rich listener as a per-user LaunchAgent (runs in the background, restarts at login).
# Remove with: launchctl bootout gui/$(id -u)/com.katedeys.getrich; rm ~/Library/LaunchAgents/com.katedeys.getrich.plist
cp "/Users/katedeys/job scout/scout/getrich.plist" ~/Library/LaunchAgents/com.katedeys.getrich.plist
launchctl bootout gui/$(id -u)/com.katedeys.getrich 2>/dev/null
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.katedeys.getrich.plist && echo "Get Rich listener is running"
