function fish_right_prompt
	# RPROMPT='%F{white} $(rbenv version-name) $(~/bin/git-cwd-info)%f'
	printf '%s%s%s: %sruby %s; %s%s' (set_color white) (date "+%d.%m.%Y, %H:%M") (set_color normal) (set_color white) (rbenv version-name) (git_cwd_info) (set_color normal)
end