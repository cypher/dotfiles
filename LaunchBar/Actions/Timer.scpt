on handle_string(msg)

    set duration to last word of msg
    set mLength to (count characters of msg)
    set dLength to ((count characters of duration) + 1)
    set reminder to (characters 1 thru (mLength - dLength) of msg) as string

    tell application "LaunchBar"
        display in large type reminder after delay duration
        delay
    end tell

end handle_string
