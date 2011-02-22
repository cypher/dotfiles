#!/bin/sh
# post-checkout hook
# Via http://tbaggery.com/2011/02/07/bundle-while-you-git.html

if [ $1 = 0000000000000000000000000000000000000000 ]; then
  old=4b825dc642cb6eb9a060e54bf8d69288fbee4904
else
  old=$1
fi

if [ -f Gemfile ] && command -v bundle >/dev/null && git diff --name-only $old $2 | egrep -q '^Gemfile|\.gemspec$'
then
  (unset GIT_DIR; exec bundle) | grep -v '^Using ' | grep -v ' is complete'
  true
fi
