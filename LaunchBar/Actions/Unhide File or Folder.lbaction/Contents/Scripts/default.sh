#! /bin/bash

# Clear "hidden" flag on every file passed:
for file in "$@"
do
    chflags nohidden "$file"
done
