function git_cwd_info
	set GIT_REPO_PATH (git rev-parse --git-dir 2>/dev/null)

	if [ "$GIT_REPO_PATH" != '' ]; and [ "$GIT_REPO_PATH" != '~' ]; and [ "$GIT_REPO_PATH" != "$HOME/.git" ]
		set --local GIT_BRANCH (git symbolic-ref -q HEAD | sed 's/refs\/heads\///')
		set --local GIT_COMMIT_ID (git rev-parse --short HEAD 2>/dev/null)

		if test -e "$GIT_REPO_PATH/BISECT_LOG"
			set --local GIT_MODE " +bisect"
		else if test -e "$GIT_REPO_PATH/MERGE_HEAD"
			set --local GIT_MODE " +merge"
		else if test -e "$GIT_REPO_PATH/rebase"; or test -e "$GIT_REPO_PATH/rebase-apply"; or test -e "$GIT_REPO_PATH/rebase-merge"; or test -e "$GIT_REPO_PATH/../.dotest"
			set --local GIT_MODE " +rebase"
		else
			set --local GIT_MODE ""
		end

		set --local GIT_MODIFIED_FILES (git ls-files -m)
		if test "$GIT_REPO_PATH" != '.'; and test "$GIT_MODIFIED_FILES" != ""
			# GIT_DIRTY=" %{[90m%}✗%{[0m%}"
			set --local GIT_DIRTY " ✗"
		else
			set --local GIT_DIRTY ""
		end

		# echo " %{[90m%}$GIT_BRANCH %{[37m%}$GIT_COMMIT_ID%{[0m%}$GIT_MODE$GIT_DIRTY"
		echo " $GIT_BRANCH $GIT_COMMIT_ID $GIT_MODE$GIT_DIRTY"
	end
end