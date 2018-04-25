#!/bin/bash
#https://github.com/kcrawford/dockutil

/usr/local/bin/dockutil --add '/Applications/Pages.app' /Users/$3
/usr/local/bin/dockutil --add '/Applications/Keynote.app' /Users/$3
/usr/local/bin/dockutil --add '/Applications/Microsoft Word.app' /Users/$3
/usr/local/bin/dockutil --add '/Applications/Microsoft Excel.app' /Users/$3
/usr/local/bin/dockutil --add '/Applications/Microsoft PowerPoint.app' /Users/$3
/usr/local/bin/dockutil --add '/Applications/Google Chrome.app' --after 'Safari' /Users/$3
/usr/local/bin/dockutil --add '/Applications/Self Service.app' /Users/$3
/usr/local/bin/dockutil --remove 'Messages' /Users/$3
/usr/local/bin/dockutil --remove 'Photos' /Users/$3
/usr/local/bin/dockutil --remove 'Maps' /Users/$3
/usr/local/bin/dockutil --remove 'Notes' /Users/$3
/usr/local/bin/dockutil --remove 'Reminders' /Users/$3
/usr/local/bin/dockutil --remove 'Calendar' /Users/$3
/usr/local/bin/dockutil --remove 'App Store' /Users/$3
/usr/local/bin/dockutil --remove 'Mail' /Users/$3
/usr/local/bin/dockutil --remove 'iBooks' /Users/$3
/usr/local/bin/dockutil --remove 'Siri' /Users/$3
/usr/local/bin/dockutil --remove 'Launchpad' /Users/$3
/usr/local/bin/dockutil --remove 'Contacts' /Users/$3
/usr/local/bin/dockutil --remove 'FaceTime' /Users/$3
/usr/local/bin/dockutil --remove 'iTunes' /Users/$3
/usr/local/bin/dockutil --remove 'iBooks' /Users/$3
