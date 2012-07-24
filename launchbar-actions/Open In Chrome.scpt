--
-- open currently open URL in Safari in Chrome
-- useful as a Launchbar action in ~/Library/Application Support/Launchbar/Actions
-- forked from https://gist.github.com/3151932
--
property theURL : ""
tell application "Safari"
	set theURL to URL of current tab of window 1
end tell
if appIsRunning("Google Chrome") then
	tell application "Google Chrome"
		tell window 1
			set newTab to make new tab with properties {URL:theURL}
		end tell
		activate
	end tell
else
	tell application "Google Chrome"
		do shell script "open -a \"Google Chrome\""
		set URL of active tab of window 0 to theURL
		activate
	end tell
end if

on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning