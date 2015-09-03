function fish_prompt --description 'Write out the prompt'
    # Old ZSH prompt config:
    # setopt prompt_subst
    # Combined left and right prompt configuration.
    # local smiley="%(?,%F{green}☺%f,%F{red}☹%f)"
    #
    # PROMPT='%m %B%F{red}:: %F{green}%3~ ${smiley} %F{blue}%(0!.#.») %b%f'
    # RPROMPT='%F{white} $(rbenv version-name) $(~/bin/git-cwd-info)%f'

	set -l last_status $status

	if not set -q __fish_prompt_normal
		set -g __fish_prompt_normal (set_color normal)
	end

	# PWD
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal

	printf '%s ' (__fish_git_prompt)

	if not test $last_status -eq 0
	set_color $fish_color_error
	end

	echo -n '$ '

	set_color normal
end
