#!/bin/sh

#Check conection to JSS
if ! jamf checkJSSConnection -retry 20; then
    osascript -e 'Can not connect to JSS - aborting'
    exit 1;
fi

#Find PID for running AppleScript prompt, kill it and delete it
pid=$(pgrep -f "DEP First Run")
kill $pid
rm -R /Users/Shared/DEP\ First\ Run.app 


# Loop until valid input is entered or Cancel is pressed.
while :; do
    computerName=$(osascript -e 'Tell application "System Events" to display dialog "Computer Name" default answer ""' -e 'text returned of result' 2>/dev/null)

    if (( $? ));
        then exit 1; fi  # Abort, if user pressed Cancel.

        computerName=$(echo "$computerName" | sed 's/^ *//' | sed 's/ *$//')  # Trim leading and trailing whitespace.
	
	    computerName=$(echo "$computerName" | sed 's/ /-/g')  # Replace spaces with -

    if [[ -z "$computerName" ]]; then

        # The user left the name blank
        osascript -e 'Tell application "System Events" to display alert "You must enter a computer name. Please try again" as warning' >/dev/null

        # Continue loop to prompt again.
        else
            # Valid input: exit loop and continue.
            break
    fi
done

#Download logo for DEP Notify to display
curl -o /tmp/logo.png https://www.domain.org/sites/default/files/logo.png

#Launch DEP Notify
#https://gitlab.com/Mactroll/DEPNotify
/Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify -jamf &
echo "Command: Image: /tmp/logo.png" >> /var/tmp/depnotify.log
echo "Command: MainText: This will step through setting up the Mac OS, installing default apps and settings and JAMF (Casper)." >> /var/tmp/depnotify.log
echo "Command: MainTitle: High Sierra Image" >> /var/tmp/depnotify.log
echo "Command: Determinate: 9" >> /var/tmp/depnotify.log

echo "Status: The JAMF setup process has started." >> /var/tmp/depnotify.log
sleep 1

echo "Status: Setting local computer name" >> /var/tmp/depnotify.log
sleep 1
/usr/sbin/scutil --set ComputerName ${computerName}
/usr/sbin/scutil --set LocalHostName ${computerName}
/usr/sbin/scutil --set HostName ${computerName}

echo "Status: Computer name has been set..." >> /var/tmp/depnotify.log
sleep 1

echo "Status: Joining computer to AD" >> /var/tmp/depnotify.log
jamf bind -type ad  -domain 'name.domain' -username "user" -passhash "*******" -ou "OU=Computers,DC=name,DC=domain" -localHomes -mountStyle smb -defaultShell "/bin/bash" -multipleDomains -useUNCPath
dscacheutil -flushcache

echo "Status: Running JAMF recon" >> /var/tmp/depnotify.log
sleep 1
/usr/local/bin/jamf recon

echo "Status: Starting core app install"  >> /var/tmp/depnotify.log
sleep 1
sudo jamf policy -id 5281

exit 0