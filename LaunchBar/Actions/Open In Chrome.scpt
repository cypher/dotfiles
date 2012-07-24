--
-- open currently open URL in Safari in Chrome
-- forked from https://gist.github.com/3151932
--
property theURL : ""
tell application "Safari"
	set theURL to URL of current tab of window 1
end tell

if appIsRunning("Google Chrome") then
	tell application "Google Chrome"
		if (count of (every window where visible is true)) is greater than 0 then
			-- running with a visible window, ready for new tab
		else
			-- running but no visible window, so create one
			make new window
		end if
	end tell
else
	tell application "Google Chrome"
		-- chrome app not running, so start it
		do shell script "open -a \"Google Chrome\""
	end tell
end if

-- now that we have made sure chrome is running and has a visible
-- window create a new tab in that window
-- and activate it to bring to the front
tell application "Google Chrome"
	tell front window
		make new tab with properties {URL:theURL}
	end tell
	activate
end tell

on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning
