#!/bin/bash

# Setup DND on NotificationCenter
MAC_UUID=$(system_profiler SPHardwareDataType | awk -F" " '/UUID/{print $3}')
/usr/bin/defaults write /Users/$3/Library/Preferences/ByHost/com.apple.notificationcenterui.$MAC_UUID "dndEnd" -float 1379
/usr/bin/defaults write /Users/$3/Library/Preferences/ByHost/com.apple.notificationcenterui.$MAC_UUID "doNotDisturb" -bool FALSE
/usr/bin/defaults write /Users/$3/Library/Preferences/ByHost/com.apple.notificationcenterui.$MAC_UUID "dndStart" -float 1380
chown $3 /Users/$3/Library/Preferences/ByHost/com.apple.notificationcenterui.$MAC_UUID.plist
chmod 755 /Users/$3/Library/Preferences/ByHost/com.apple.notificationcenterui.$MAC_UUID.plist
killall NotificationCenter

#Disable first time login Apple prompts
/usr/bin/defaults write /Users/$3/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
/usr/bin/defaults write /Users/$3/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
/usr/bin/defaults write /Users/$3/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
/usr/bin/defaults write /Users/$3/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
/usr/bin/defaults write /Users/$3/Library/Preferences/com.apple.SetupAssistant DidSeePrivacy -bool TRUE
/usr/bin/defaults write /Users/$3/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE        

# Dismiss all the touristd 'tours'
/System/Library/PrivateFrameworks/Tourist.framework/Versions/A/Resources/touristd dismiss

# Create Downloads Symlink
ln -s /Users/$3/Downloads /Users/$3/Desktop 

# Fix Office Default Save Location
getUser=`ls -l /dev/console | awk '{ print $3 }'`
defaults write /Users/$getUser/Library/Group\ Containers/UBF8T346G9.Office/com.microsoft.officeprefs.plist DefaultsToLocalOpenSave -bool TRUE
/bin/chmod -R 700 /Users/$getUser/Library/Group\ Containers
/usr/sbin/chown -R $getUser: /Users/$getUser/Library/Group\ Containers

# Open Google Drive FS
open /Applications/Google\ Drive\ File\ Stream.app

# Disable Office Auto Update
/usr/bin/defaults write /Users/$3/Library/Preferences/com.microsoft.autoupdate2 HowToCheck Manual

# Set Safari to not auto open downloads
/usr/bin/defaults write /Users/"$3"/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false

# Show all file extensions
/usr/bin/defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set desktop background for logged in user
#sudo -u $loggedInUser osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/path/to/desktop/background.jpg"'
