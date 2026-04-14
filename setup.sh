#!/bin/bash

echo ""
echo "Welcome to MojiPicker!"
echo "This script will make a DeveloperSettings.xcconfig file."
echo ""
read -p "Press enter to start…"

echo ""
echo "What is your Developer Team ID? You can find it at developer.apple.com."
read devTeamID

mkdir -p MojiPicker\ demo/Configuration

cat <<file > MojiPicker\ demo/Configuration/DeveloperSettings.xcconfig
DEVELOPMENT_TEAM = $devTeamID
file

echo ""
echo "Done! You can now open MojiPicker.xcworkspace and build the demo app."
