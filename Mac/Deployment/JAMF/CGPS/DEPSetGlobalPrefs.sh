#!/bin/sh

#Date / Time
/usr/sbin/systemsetup -settimezone "America/New_York"

#Set some global settings
defaults write /Library/Preferences/com.apple.mdmclient BypassPreLoginCheck -bool YES
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
sudo security authorizationdb write system.device.dvd.setregion.initial allow
sudo security authorizationdb read system.device.dvd.setregion.initial

#Lockdown Wifi
if [[ $(sysctl hw.model) == *"iMac"* ]]; then
    #networksetup -setairportpower en1 off
    /usr/libexec/airportd en1 prefs RequireAdminIBSS=YES
    /usr/libexec/airportd en1 prefs RequireAdminNetworkChange=YES
    /usr/libexec/airportd en1 prefs RequireAdminPowerToggle=YES
    /usr/libexec/airportd en1 prefs RememberRecentNetworks=NO
elif [[ $(sysctl hw.model) == *"MacBook"* ]]; then
    #networksetup -setairportpower en0 on
    #networksetup -setairportnetwork en0 CGPSN Pe148jTT
    /usr/libexec/airportd en0 prefs RequireAdminIBSS=YES
    /usr/libexec/airportd en0 prefs RequireAdminNetworkChange=YES
    /usr/libexec/airportd en0 prefs RequireAdminPowerToggle=YES
    /usr/libexec/airportd en0 prefs RememberRecentNetworks=NO
fi

#Enable and configure ARD
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Disable Time Machine's pop-up message whenever an external drive is plugged in
/usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Make a symbolic link from /System/Library/CoreServices/Applications/Directory Utility.app 
# to /Applications/Utilities so that Directory Utility.app is easier to access.

if [[ ! -e "/Applications/Utilities/Directory Utility.app" ]]; then
   /bin/ln -s "/System/Library/CoreServices/Applications/Directory Utility.app" "/Applications/Utilities/Directory Utility.app"
fi

if [[ -L "/Applications/Utilities/Directory Utility.app" ]]; then
   /bin/rm "/Applications/Utilities/Directory Utility.app"
   /bin/ln -s "/System/Library/CoreServices/Applications/Directory Utility.app" "/Applications/Utilities/Directory Utility.app"
fi

# Make a symbolic link from /System/Library/CoreServices/Applications/Network Utility.app 
# to /Applications/Utilities so that Network Utility.app is easier to access.

if [[ ! -e "/Applications/Utilities/Network Utility.app" ]]; then
   /bin/ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"
fi

if [[ -L "/Applications/Utilities/Network Utility.app" ]]; then
   /bin/rm "/Applications/Utilities/Network Utility.app"
   /bin/ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"
fi

# Make a symbolic link from /System/Library/CoreServices/Screen Sharing.app 
# to /Applications/Utilities so that Screen Sharing.app is easier to access.

if [[ ! -e "/Applications/Utilities/Screen Sharing.app" ]]; then
   /bin/ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"
fi

if [[ -L "/Applications/Utilities/Screen Sharing.app" ]]; then
   /bin/rm "/Applications/Utilities/Screen Sharing.app"
   /bin/ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"
fi

# Set the ability to  view additional system info at the Login window
# The following will be reported when you click on the time display 
# (click on the time again to proceed to the next item):
#
# Computer name
# Version of OS X installed
# IP address
# This will remain visible for 60 seconds.

/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Sets the "Show scroll bars" setting (in System Preferences: General)
# to "Always" in your Mac's default user template and for all existing users.
# Code adapted from DeployStudio's rc130 ds_finalize script, where it's 
# disabling the iCloud and gestures demos

# Checks the system default user template for the presence of 
# the Library/Preferences directory. If the directory is not found, 
# it is created and then the "Show scroll bars" setting (in System 
# Preferences: General) is set to "Always".

for USER_TEMPLATE in "/System/Library/User Template"/*
  do
     if [ ! -d "${USER_TEMPLATE}"/Library/Preferences ]
      then
        /bin/mkdir -p "${USER_TEMPLATE}"/Library/Preferences
     fi
     if [ ! -d "${USER_TEMPLATE}"/Library/Preferences/ByHost ]
      then
        /bin/mkdir -p "${USER_TEMPLATE}"/Library/Preferences/ByHost
     fi
     if [ -d "${USER_TEMPLATE}"/Library/Preferences/ByHost ]
      then
        /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/.GlobalPreferences AppleShowScrollBars -string Always
     fi
  done
  
# Determine OS version and build version
# as part of the following actions to disable
# the iCloud and Diagnostic pop-up windows

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)
sw_build=$(sw_vers -buildVersion)


# Checks first to see if the Mac is running 10.7.0 or higher. 
# If so, the script checks the system default user template
# for the presence of the Library/Preferences directory. Once
# found, the iCloud, Diagnostic and Siri pop-up settings are set 
# to be disabled.

if [[ ${osvers} -ge 7 ]]; then

 for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeePrivacy -bool TRUE
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
  done

 # Checks first to see if the Mac is running 10.7.0 or higher.
 # If so, the script checks the existing user folders in /Users
 # for the presence of the Library/Preferences directory.
 #
 # If the directory is not found, it is created and then the
 # iCloud, Diagnostic and Siri pop-up settings are set to be disabled.

 for USER_HOME in /Users/*
  do
    USER_UID=`basename "${USER_HOME}"`
    if [ ! "${USER_UID}" = "Shared" ] 
    then 
      if [ ! -d "${USER_HOME}"/Library/Preferences ]
      then
        /bin/mkdir -p "${USER_HOME}"/Library/Preferences
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ -d "${USER_HOME}"/Library/Preferences ]
      then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeePrivacy -bool TRUE
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
      fi
    fi
  done
fi

#Run JAMF policies to configure the admin dock
echo "Status: Setitng admin dock."  >> /var/tmp/depnotify.log
sudo jamf policy -id 5279
sudo jamf policy -id 5280

#allow staff to add printers without being admin
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group _lpoperator

# Submit Inventory
/usr/local/bin/jamf recon

echo "Status: The JAMF setup process is now complete."  >> /var/tmp/depnotify.log
sleep 1

#Remove DEP Notify Application
echo "Command: Quit: The JAMF setup process is now complete." >> /var/tmp/depnotify.log
rm /var/tmp/depnotify.log
rm -R /Applications/Utilities/DEPNotify.app

exit 0