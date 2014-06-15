#! /bin/bash

# Set "hidden" flag on every file passed:
for file in "$@"
do
    chflags hidden "$file"
done
