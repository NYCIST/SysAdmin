display dialog "Setup machine with JAMF/DEP?"
set result to button returned of result
if result is "OK" then
	do shell script "sudo /usr/local/bin/jamf policy -event dep > /dev/null 2>&1 &" with administrator privileges
	set progress total steps to 20
	set progress completed steps to 0
	set progress description to "Initializing JAMF/DEP setup"	
	repeat with a from 1 to 20
		set progress completed steps to a
		delay 1
	end repeat
end if