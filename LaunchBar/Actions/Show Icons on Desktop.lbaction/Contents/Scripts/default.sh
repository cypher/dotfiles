#! /bin/bash

# Setting "CreateDesktop" to false in the domain com.apple.finder causes the
# Desktop to disappear. To make it reappear, the preference must either be set
# to true or deleted altogether. By default, it is not set at all so we choose
# to delete the preference from the domain again.
# Trying to delete the preference if it doesn't exist logs an error, so so we
# redirect the standard error to /dev/null
defaults delete com.apple.finder CreateDesktop 2> /dev/null

# Restart Finder so it picks up the changes:
killall Finder
