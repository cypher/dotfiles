# Sourced in interactive shells

## keybindings (run 'bindkeys' for details, more details via man zshzle)
# use emacs style per default:
bindkey -e
# use vi style:
# bindkey -v

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

autoload -U zmv
alias mmv='noglob zmv -W'

autoload -U history-search-end

#########################################################################################
## Completions

# This is from grml zshrc
# # completion system
# if autoload -U compinit ; then
#     compinit || print 'Notice: no compinit available :('
# else
#     print 'Notice: no compinit available :('
#     function zstyle { }
#     function compdef { }
# fi

autoload -U compinit
compinit -C
## completions ####
autoload -U zstyle+

## General completion technique
## complete as much as you can ..
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
## complete less
#zstyle ':completion:*' completer _expand _complete _list _ignored _approximate
## complete minimal
#zstyle ':completion:*' completer _complete _ignored

## determine in which order the names (files) should be
## listed and completed when using menu completion.
## `size' to sort them by the size of the file
## `links' to sort them by the number of links to the file
## `modification' or `time' or `date' to sort them by the last modification time
## `access' to sort them by the last access time
## `inode' or `change' to sort them by the last inode change time
## `reverse' to sort in decreasing order
## If the style is set to any other value, or is unset, files will be
## sorted alphabetically by name.
zstyle ':completion:*' file-sort name

## case-insensitive (uppercase from lowercase) completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## completion caching
zstyle ':completion:*' use-cache 1
# zstyle ':completion:*' cache-path ~/.zcompcache/$HOST

## add colors to completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

### If you want zsh's completion to pick up new commands in $path automatically
### comment out the next line and un-comment the following 5 lines
zstyle ':completion:::::' completer _complete _approximate
#_force_rehash() {
#  (( CURRENT == 1 )) && rehash
#  return 1# Because we didn't really complete anything
#}
#zstyle ':completion:::::' completer _force_rehash _complete _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes

zstyle ':completion:*:kill:*:processes' command "ps x"

fpath=(${HOME}/.zsh/functions/ $fpath)
autoload $^fpath/*(N:t)

#########################################################################################
# Colors

autoload colors; colors;

# Based on http://twitter.com/evanphx/status/2021488509
# PS1="%m :: %2~ %B»%b "
PROMPT="%m %B%F{red}::%b %B%F{green}%3~%(0?. . %F{red}%? )%F{blue}%(0!.#.»)%b%F{white} "

unset LSCOLORS
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

#########################################################################################
# Some options

# history:
setopt append_history       # append history list to the history file (important for multiple parallel zsh sessions!)
setopt SHARE_HISTORY        # import new commands from the history file also in other zsh-session
setopt extended_history     # save each command's beginning timestamp and the duration to the history file
setopt hist_ignore_all_dups # If  a  new  command  line being added to the history
                            # list duplicates an older one, the older command is removed from the list
setopt hist_ignore_space    # remove command lines from the history list when
                            # the first character on the line is a space
HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=10000              # useful for setopt append_history


setopt auto_cd              # if a command is issued that can't be executed as a normal command,
                            # and the command is the name of a directory, perform the cd command to that directory

setopt extended_glob        # in order to use #, ~ and ^ for filename generation
                            # grep word *~(*.gz|*.bz|*.bz2|*.zip|*.Z) ->
                            # -> searches for word not in compressed files
                            # don't forget to quote '^', '~' and '#'!

setopt longlistjobs         # display PID when suspending processes as well

setopt notify               # report the status of backgrounds jobs immediately

setopt hash_list_all        # Whenever a command completion is attempted, make sure
                            # the entire command path is hashed first.

setopt completeinword       # not just at the end

setopt nohup                # and don't kill them, either

# setopt auto_pushd         # make cd push the old directory onto the directory stack.

setopt nonomatch            # try to avoid the 'zsh: no matches found...'

setopt nobeep               # avoid "beep"ing

setopt pushd_ignore_dups    # don't push the same dir twice.

setopt noglobdots           # * shouldn't match dotfiles. ever.

setopt long_list_jobs       # List jobs in long format

#########################################################################################

# do we have GNU ls with color-support?
if ls --help 2>/dev/null | grep -- --color= >/dev/null && [[ "$TERM" != dumb ]] ; then
    # execute  ls with colors
    alias ls='ls -bh -CF --color=auto'
    # execute  list all files, with colors
    alias la='ls -lhAF --color=auto'
    # long colored list, without dotfiles
    alias ll='ls -lh --color=auto'
    # long colored list, human readable sizes
    alias lh='ls -hAl --color=auto'
    # List files, append qualifier to filenames, / for directories, @ for symlinks ...
    alias l='ls -lhF --color=auto'
else
    alias ls='ls -bh -CF'
    alias la='ls -lhAF'
    alias ll='ls -lh'
    alias lh='ls -hAl'
    alias l='ls -lhF'
fi

alias .='pwd'
alias '..'='cd ..'
# The -g makes them global aliases, so they're expaned even inside commands
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
# Aliases '-' to 'cd -'
alias -- -='cd -'

alias cp='nocorrect cp'         # no spelling correction on cp
alias mkdir='nocorrect mkdir'   # no spelling correction on mkdir
alias mv='nocorrect mv'         # no spelling correction on mv
alias rm='nocorrect rm'         # no spelling correction on rm

# Execute rmdir
alias rd='rmdir'
# Execute rmdir
alias md='mkdir -p'

# general
# Execute du -sch
alias da='du -sch'
# Execute jobs -l
alias j='jobs -l'

# listing stuff
#  Execute ls -lSrah
alias dir="ls -lSrah"
#  Only show dot-directories
alias lad='ls -d .*(/)'                # only show dot-directories
#  Only show dot-files
alias lsa='ls -a .*(.)'                # only show dot-files
#  Only files with setgid/setuid/sticky flag
alias lss='ls -l *(s,S,t)'             # only files with setgid/setuid/sticky flag
#  Only show 1st ten symlinks
alias lsl='ls -l *(@[1,10])'           # only symlinks
#  Display only executables
alias lsx='ls -l *(*[1,10])'           # only executables
#  Display world-{readable,writable,executable} files
alias lsw='ls -ld *(R,W,X.^ND/)'       # world-{readable,writable,executable} files
#  Display the ten biggest files
alias lsbig="ls -flh *(.OL[1,10])"     # display the biggest files
#  Only show directories
alias lsd='ls -d *(/)'                 # only show directories
#  Only show empty directories
alias lse='ls -d *(/^F)'               # only show empty directories
#  Display the ten newest files
alias lsnew="ls -rl *(D.om[1,10])"     # display the newest files
#  Display the ten oldest files
alias lsold="ls -rtlh *(D.om[1,10])"   # display the oldest files
#  Display the ten smallest files
alias lssmall="ls -Srl *(.oL[1,10])"   # display the smallest files

# chmod
alias rw-='chmod 600'
alias rwx='chmod 700'
alias r--='chmod 644'
alias r-x='chmod 755'

#########################################################################################
# Custom aliases/commands

# Convert a picture to a favicon
alias make-favicon="convert -colors 256 -resize 16x16 "

# Alias m to a sane value, even if not on a mac
if [[ -f $(which mate_wait) ]]; then
    alias m='mate'
    alias m.='mate .'
else
    alias m="${EDITOR}"
    alias m.="${EDITOR} ."
fi

if [[ -f $(which mvim) ]]; then
    alias v='mvim'
    alias v.='mvim .'
else
    alias v='vim'
    alias v.='vim .'
fi

if [[ -x "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]]; then
    alias e='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait'
    alias e.='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait .'
else
    alias e='emacsclient --no-wait'
    alias e.='emacsclient --no-wait .'
fi

# Start or resume irssi
function irc () {
    if grep irc <<< `screen -ls`; then
        screen -x irc
    else
        screen -S irc irssi
    fi
}

# Start or resume irssi in freenode config
function freenode () {
    # TODO: Check for freenode instance here, not just irssi
    if grep freenode <<< `screen -ls`; then
        screen -x freenode
    else
        screen -S freenode irssi --config=${HOME}/.irssi/freenode
    fi
}

# TODO: Make sure this only executes on eschaton:
function update-repos () {
    pushd ~/Code/
    thor scm:update
    popd
    pushd ~/Projects
    thor scm:fetch
    popd
    pushd ~/GitHub
    for name in *
    do
        ~/bin/githubsync.py $name $name
    done
    popd
    pushd ~/dotfiles
    git remote update
    popd
}

function rot13 () { tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" }

function update-clj () {
    pushd ~/Code/clojure
    output=$(git pull)
    echo $output
    if [[ $output != "Already up-to-date." ]]; then
        ant
        # No need to update symlink, as the ant task always regenerates clojure.jar as well
    fi
    popd

    pushd ~/Code/clojure-contrib
    output=$(git pull)
    echo $output
    if [[ $output != "Already up-to-date." ]]; then
        mvn package

        # TODO: Improve this so it actually selects the just build jar
        clojure_contrib_jar=$(ls -1 `pwd`/target/clojure-contrib-*.jar | tail -n 1)

        ln -sf $clojure_contrib_jar ~/classes/clojure-contrib.jar
    fi
    popd
}

alias eject='hdiutil eject'

# Copy the working dir to the clipboard
alias cpwd='pwd|xargs echo -n|pbcopy'

# Show current airport status:
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

# Use spotlight to search for a file:
spotlightfile() {
  mdfind "kMDItemDisplayName == '$@'wc";
}

# Use spotlight to search file contents:
spotlightcontent() {
  mdfind -interpret "$@";
}

# View man pages in Preview
pdfman () {
  man -t $1 | open -a /Applications/Preview.app -f
}

alias lockscreen="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

alias inode="rlwrap node-repl"

if [[ -x "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]]; then
    alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi

alias httpdump='sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E "Host\: .*|GET \/.*"'

# mkdir, cd into it (via http://onethingwell.org/post/586977440/mkcd-improved)
mkcd () {
    mkdir -p "$*"
    cd "$*"
}

ydl () {
    for url ($*) youtube-dl -td "$url" || youtube-dl -tb "$url"
}

if [[ -x `which bcat` ]]; then
    # If bcat (Browser cat, http://rtomayko.github.com/bcat/) is invoked as `btee', it acts like `tee(1)'
    alias btee=bcat
fi

#########################################################################################
# Ruby aliases/functions

alias rubydo="rvm rubydo"
alias multiruby="rvm rubydo"

alias macirb="macirb --readline -r irb/completion --simple-prompt"

alias h="heroku"

# For Rails:
alias sc='./script/console'
alias sg='./script/generate'
alias ss='./script/server'
alias sd='./script/destroy'

# For Rails 3:
alias rc='rails console'
alias rg='rails generate'
alias rs='rails server'

alias r='rake'
alias t='thor'

alias restart='touch tmp/restart.txt'
alias migrate='rake db:migrate && rake db:test:prepare'

#########################################################################################
# Git aliases/functions

# Aliases git to hub
# eval `hub alias -s zsh`
alias g='git'
alias gb='git branch -a -v'
alias gs='git status'
alias gd='git diff'

# gc => git checkout master
# gc bugs => git checkout bugs
function gc () {
    if [[ -z "$1" ]]; then
        git checkout master
    else
        git checkout $1
    fi
}

function git-track () {
    branch=$(git branch | sed -ne 's/^\*\ \(.*\)$/\1/p')
    git config branch.$branch.remote origin
    git config branch.$branch.merge refs/heads/$branch
    echo "tracking origin/$branch"
}

function update-git () {
    if [[ -d ~/Code/Git ]]; then
        pushd ~/Code/Git
    elif [[ -d ~/src/git ]]; then
        pushd ~/src/git
    else
        print "Could not find Git source dir. Bailing..."
        return 1
    fi

    output=$(git pull)
    echo $output

    if [[ $output != "Already up-to-date." ]]; then
        make prefix=/usr/local BLK_SHA1=1 NO_TCLTK=1 all
        if [[ -O /usr/local ]]; then
            make prefix=/usr/local BLK_SHA1=1 NO_TCLTK=1 install quick-install-man
        else
            sudo make prefix=/usr/local BLK_SHA1=1 NO_TCLTK=1 install quick-install-man
        fi
    fi

    git --version
    popd
}

if [[ -e "${HOME}/.git-completion.sh" ]]; then
    # Enable bash completion for git
    # This should allow git-completion to work properly
    alias shopt=setopt
    autoload bashcompinit
    bashcompinit

    source ~/.git-completion.sh
    # Autocomplete for 'gh' as well
    complete -o default -o nospace -F _git gh
    # Autocomplete for 'g' as well
    complete -o default -o nospace -F _git g
fi

_git_remote_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    if (( CURRENT == 2 )); then
      # first arg: operation
      compadd create publish rename delete track
    elif (( CURRENT == 3 )); then
      # second arg: remote branch name
      compadd `git branch -r | grep -v HEAD | sed "s/.*\///" | sed "s/ //g"`
    elif (( CURRENT == 4 )); then
      # third arg: remote name
      compadd `git remote`
    fi
  else;
    _files
  fi
}
compdef _git_remote_branch grb

#########################################################################################
# Node

# nvm, the node version manager
NVM_DIR=$HOME/.nvm
source $NVM_DIR/nvm.sh
# nvm use v0.1.91

#########################################################################################
# SSH

# Auto-completion for ssh hosts
zstyle -e ':completion::*:hosts' hosts 'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" /etc/ssh_known_hosts(N) ~/.ssh/known_hosts(N) 2>/dev/null | xargs) $(grep \^Host ~/.ssh/config(N) | cut -f2 -d\  2>/dev/null | xargs))'

#########################################################################################
# Grep stuff

# Grep in history
function greph () { history 0 | grep -i $1 }
# use colors when GNU grep with color-support
#  Execute grep --color=auto
if (grep --help 2>/dev/null |grep -- --color) >/dev/null; then
    alias grep='grep --color=auto'
fi

#########################################################################################
## Functions for displaying neat stuff in *term title

# format titles for screen and rxvt
function title () {
    # escape '%' chars in $1, make nonprintables visible
    a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")

    case $TERM in
    screen)
    print -Pn "\ek$a:$3\e\\"      # screen title (in ^A")
    ;;
    xterm*|rxvt)
    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
    ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd () {
    title "zsh" "$USER@%m" "%55<...<%~"
}

# preexec is called just before any command line is executed
function preexec () {
    title "$1" "$USER@%m" "%35<...<%~"
}


#########################################################################################
# Set terminal to UTF-8/ISO mode

# # see http://www.cl.cam.ac.uk/~mgk25/unicode.html#term for details
# alias term2iso="echo 'Setting terminal to iso mode' ; print -n '\e%@'"
# alias term2utf="echo 'Setting terminal to utf-8 mode'; print -n '\e%G'"
# 
# # make sure it is not assigned yet
# [[ $(whence -w utf2iso &>/dev/null) == 'utf2iso: alias' ]] && unalias utf2iso
# 
# utf2iso() {
#     if isutfenv ; then
#         for ENV in $(env | command grep -i '.utf') ; do
#             eval export "$(echo $ENV | sed 's/UTF-8/iso885915/ ; s/utf8/iso885915/')"
#         done
#     fi
# }
# 
# # make sure it is not assigned yet
# [[ $(whence -w iso2utf &>/dev/null) == 'iso2utf: alias' ]] && unalias iso2utf
# iso2utf() {
#     if ! isutfenv ; then
#         for ENV in $(env | command grep -i '\.iso') ; do
#             eval export "$(echo $ENV | sed 's/iso.*/UTF-8/ ; s/ISO.*/UTF-8/')"
#         done
#     fi
# }

#########################################################################################
# Insert Unicode character

# I'm not using this (yet)
# # insert unicode character
# # usage example: 'ctrl-x i' 00A7 'ctrl-x i' will give you an §
# # See for example http://unicode.org/charts/ for unicode characters code
# autoload -U insert-unicode-char
# zle -N insert-unicode-char
# #k# Insert Unicode character
# bindkey '^Xi' insert-unicode-char

# rvm-install added line:
if [[ -s ${HOME}/.rvm/scripts/rvm ]] ; then source ${HOME}/.rvm/scripts/rvm ; fi
