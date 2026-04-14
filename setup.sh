#!/bin/bash

echo ""
echo "Welcome to MojiPicker!"
echo "This script will make a DeveloperSettings.xcconfig file."
echo ""
read -p "Press enter to start…"

echo ""
echo "What is your Developer Team ID? You can find it at developer.apple.com."
read devTeamID
echo ""
echo "What is your Organization Identifier? (e.g. com.yourname)"
read orgID

cat <<file > MojiPicker\ demo/MojiPicker\ demo/Resources/DeveloperSettings.xcconfig
DEVELOPMENT_TEAM = $devTeamID
PRODUCT_BUNDLE_IDENTIFIER = $orgID.mojipicker-demo
file

echo ""
echo "Done! You can now open MojiPicker.xcworkspace and build the demo app."
