#!/bin/bash

# Emits Git metadata for use in a Zsh prompt.
#
# Based on Geoffrey Grosenbach's modified version of:
#   https://github.com/benhoskings/dot-files/blob/master/files/bin/git_cwd_info
#
# Rewritten as shell script simply for speed

GIT_REPO_PATH=`git rev-parse --git-dir 2>/dev/null`

if [[ $GIT_REPO_PATH != '' && $GIT_REPO_PATH != '~' && $GIT_REPO_PATH != "$HOME/.git" ]]; then

  GIT_BRANCH=`git symbolic-ref -q HEAD | sed 's/refs\/heads\///'`
  GIT_COMMIT_ID=`git rev-parse --short HEAD 2>/dev/null`

  GIT_MODE=""
  if [[ -e "$GIT_REPO_PATH/BISECT_LOG" ]]; then
    GIT_MODE=" +bisect"
  elif [[ -e "$GIT_REPO_PATH/MERGE_HEAD" ]]; then
    GIT_MODE=" +merge"
  elif [[ -e "$GIT_REPO_PATH/rebase" || -e "$GIT_REPO_PATH/rebase-apply" || -e "$GIT_REPO_PATH/rebase-merge" || -e "$GIT_REPO_PATH/../.dotest" ]]; then
    GIT_MODE=" +rebase"
  fi

  GIT_DIRTY=""
  if [[ "$GIT_REPO_PATH" != '.' && `git ls-files -m` != "" ]]; then
    GIT_DIRTY=" %{[90m%}✗%{[0m%}"
  fi

  echo " %{[90m%}$GIT_BRANCH %{[37m%}$GIT_COMMIT_ID%{[0m%}$GIT_MODE$GIT_DIRTY"
fi
