#! /bin/bash

# Clear quarantine flag on every file passed, then open it:
for f in "$@"
do
	xattr -d com.apple.quarantine "$f"
	open "$f"
done
