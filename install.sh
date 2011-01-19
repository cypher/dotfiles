#!/bin/sh

# Very simple install script

for file in `find ${PWD} -maxdepth 1 -not -name '.*' -not -name install.sh -not -name bin -not -name tasks -not -name etc -not README.txt -not LICENSE -type f`; do
    filename=`basename "$file"`
    echo "ln -s `pwd`/$filename -> ~/.$filename"
    ln -s `pwd`/$filename ~/.$filename
done

mkdir -p ~/bin/
for file in `find ${PWD}/bin/ -maxdepth 1 -not -name '.*'`; do
    filename=`basename "$file"`
    echo "ln -s `pwd`/$filename -> ~/bin/$filename"
    ln -s `pwd`/$filename ~/bin/$filename
done

# Special case: Make bin/git-reup a link to git-up
if [[-e ~/bin/git-up ]]; then
    ln -s ~/bin/git-up ~/bin/git-reup
fi
