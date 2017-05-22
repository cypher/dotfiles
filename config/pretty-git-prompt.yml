# configuration parameters are descrbed on first occurence only
#
# version of configuration file (required), type string
# right now it needs to be set to '1'
version: '1'
# configuration of various values (required), type dict
# if you omit a value, it won't be displayed
values:
      # usually repository is in state 'clean' (which is not displayed)
      # but it can also be in state like merge, rebase, cherry-pick -- this is displayed then
    - type: repository_state
      # formatting (required), both (pre_format, post_format) are required
      # you can include coloring in pre_format and reset colors in post_format
      # you can also include arbitrary string
      # for more information about setting colors for zsh:
      # https://wiki.archlinux.org/index.php/zsh#Colors
      # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects
      # and bash:
      # https://www.ibm.com/developerworks/linux/library/l-tip-prompt/
      #
      # this is how the value is formatted in the end:
      #   [pre_format][value][post_format]
      pre_format: ''
      post_format: ''
      # this is used to separate values between each other
      # if there is no value displayed before or after separator, separator is not displayed either
    - type: separator
      display: surrounded
      pre_format: '│'
      post_format: ''
      # monitor status against different remotes - track history divergence
    - type: remote_difference
      # remote branch name (optional), type string
      # example: 'upstream/master'
      # if omitted look for remotely tracked branch usually set up with:
      #   git branch --set-upstream-to
      # remote_branch: ''
      # display the remote even if there is no difference with current branch (required), type bool
      display_if_uptodate: true
      pre_format: ''
      post_format: ''
      # values which can be displayed as part of 'remote_difference'
      values:
          # formatting for remote name and branch name
        - type: name
          # there are some special values which are substituted:
          #  * <REMOTE> will be replaced with name of a remote
          #  * <LOCAL_BRANCH> will be replaced with current branch name
          #  * <REMOTE_BRANCH> will be replaced with name of remote branch
          pre_format: '%{%F{blue}%}<LOCAL_BRANCH>'
          post_format: '%{%f%}'
          # the number of files present locally which are missing in remote repo
        - type: ahead
          pre_format: '%{%F{white}%}↑'
          post_format: '%{%f%}'
          # the number of commits present in remote repo which are missing locally
        - type: behind
          pre_format: '%{%F{white}%}↓'
          post_format: '%{%f%}'
    - type: separator
      display: surrounded
      pre_format: '│'
      post_format: ''
    - type: remote_difference
      remote_branch: 'upstream/master'
      display_if_uptodate: false
      pre_format: ''
      post_format: ''
      values:
        - type: name
          pre_format: '%{%F{green}%}<REMOTE>'
          post_format: '%{%f%}'
        - type: ahead
          pre_format: '%{%F{white}%}↑'
          post_format: '%{%f%}'
        - type: behind
          pre_format: '%{%F{white}%}↓'
          post_format: '%{%f%}'
    - type: separator
      display: surrounded
      pre_format: '│'
      post_format: ''
      # the number of untracked files
    - type: new
      pre_format: '%{%F{014}%}✚'
      post_format: '%{%f%}'
      # the number of tracked files which were changed in working tree
    - type: changed
      pre_format: '%{%B%F{red}%}Δ'
      post_format: '%{%b%f%}'
      # the number of files added to index
    - type: staged
      pre_format: '%{%F{green}%}▶'
      post_format: '%{%f%}'
      # during merge, rebase, or others, the numbers files which conflict
    - type: conflicts
      pre_format: '%{%F{yellow}%}✖'
      post_format: '%{%f%}'
