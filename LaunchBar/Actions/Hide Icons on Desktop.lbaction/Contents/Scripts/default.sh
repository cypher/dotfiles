#! /bin/bash

# Setting "CreateDesktop" to false in the domain com.apple.finder causes the
# Desktop to disappear.
defaults write com.apple.finder CreateDesktop -bool false

# Restart Finder so it picks up the changes:
killall Finder
