# Sourced in interactive shells

## keybindings (run 'bindkeys' for details, more details via man zshzle)
# use emacs style per default:
bindkey -e

# use vi style:
# bindkey -v

# Map jj to ESC, just like in Vim
# bindkey -M viins 'jj' vi-cmd-mode

# Enable Ctrl-R to do backwards history search
# bindkey '^R' history-incremental-search-backward

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

autoload -U history-search-end

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

#########################################################################################
## Completions

fpath=(~/.zsh/functions /usr/local/share/zsh-completions /usr/local/share/zsh/functions /usr/local/share/zsh/site-functions $fpath)
typeset -U fpath

autoload -U compinit
compinit

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
zstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}

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

# Auto-completion for ssh hosts
zstyle -e ':completion::*:hosts' hosts 'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" /etc/ssh_known_hosts(N) ~/.ssh/known_hosts(N) 2>/dev/null | xargs) $(grep \^Host ~/.ssh/config(N) | cut -f2 -d\  2>/dev/null | xargs))'

#########################################################################################
# Colors

autoload -U colors; colors;

setopt prompt_subst
# Combined left and right prompt configuration.
local smiley="%(?,%F{green}☺%f,%F{red}☹%f)"

PROMPT='%m %B%F{red}:: %F{green}%3~ ${smiley} %F{blue}%(0!.#.») %b%f'
RPROMPT='%F{white} $(rbenv version-name) $(~/bin/git-cwd-info)%f'

# TODO LSCOLORS and LS_COLORS don't define the same color scheme
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

#########################################################################################
# Some options

# history:
setopt inc_append_history   # append history list to the history file (important for multiple parallel zsh sessions!)
setopt share_history        # import new commands from the history file also in other zsh-session
setopt extended_history     # save each command's beginning timestamp and the duration to the history file
setopt hist_ignore_all_dups # If  a  new  command  line being added to the history
                            # list duplicates an older one, the older command is removed from the list
setopt hist_ignore_space    # remove command lines from the history list when
                            # the first character on the line is a space

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000              # useful for setopt append_history


setopt auto_cd              # if a command is issued that can't be executed as a normal command,
                            # and the command is the name of a directory, perform the cd command to that directory

setopt extended_glob        # in order to use #, ~ and ^ for filename generation
                            # grep word *~(*.gz|*.bz|*.bz2|*.zip|*.Z) ->
                            # -> searches for word not in compressed files
                            # don't forget to quote '^', '~' and '#'!

setopt notify               # report the status of backgrounds jobs immediately

setopt hash_list_all        # Whenever a command completion is attempted, make sure
                            # the entire command path is hashed first.

# setopt completeinword       # not just at the end

setopt nohup                # and don't kill them, either

# setopt auto_pushd         # make cd push the old directory onto the directory stack.

setopt nonomatch            # try to avoid the 'zsh: no matches found...'

setopt nobeep               # avoid "beep"ing

setopt pushd_ignore_dups    # don't push the same dir twice.

setopt noglobdots           # * shouldn't match dotfiles. ever.

setopt long_list_jobs       # List jobs in long format, display PID when suspending processes as well

#########################################################################################

# do we have GNU ls with color-support?
alias ls='ls -bh -CF'
alias la='ls -lhAF'
alias ll='ls -lh'
alias lh='ls -hAl'
alias l='ls -lhF'

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

# chmod
alias rw-='chmod 600'
alias rwx='chmod 700'
alias r--='chmod 644'
alias r-x='chmod 755'

#########################################################################################
# Custom aliases/commands

# Convert a picture to a favicon
alias make-favicon="convert -colors 256 -resize 16x16 "

# Copy the working dir to the clipboard
alias cpwd='pwd|xargs echo -n|pbcopy'

# Show current airport status:
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

alias httpdump='sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E "Host\: .*|GET \/.*"'

# mkdir, cd into it (via http://onethingwell.org/post/586977440/mkcd-improved)
function mkcd () {
    mkdir -p "$*"
    cd "$*"
}

function ydl () {
    /usr/bin/python /usr/local/bin/youtube-dl --cookies ~/.youtubedl-cookies --continue --title --console-title $*
}

# If bcat (Browser cat, http://rtomayko.github.com/bcat/) is invoked as `btee', it acts like `tee(1)'
alias btee=bcat

# sh function to murder all running processes matching a pattern
# thanks 3n: http://twitter.com/3n/status/19113206105
function murder () {
  ps | grep $1 | grep -v grep | awk '{print $1}' | xargs kill -9
}

alias dotedit="$VISUAL ~/dotfiles/"
alias homegit="GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~ git"

alias sha1='openssl dgst -sha1'
alias sha256='openssl dgst -sha256'

alias wk2png='/usr/bin/python $(which webkit2png)'

function console {
  if [[ $# > 0 ]]; then
    query=$(echo "$*" | tr -s ' ' '|')
    tail -f /var/log/system.log|grep -i --color=auto -E "$query"
  else
    tail -f /var/log/system.log
  fi
}

function backup-itunes() {
  echo "Backing up Music, Audiobooks and Books"
  rsync --update --human-readable --recursive --progress --inplace --8-bit-output ~/Music/iTunes/iTunes\ Music/{Music,Audiobooks,Books} "${ITUNES_BACKUP_DIR}";
  echo "Backing up iOS Apps"
  rsync --update --human-readable --recursive --progress --inplace --8-bit-output --delete-after ~/Music/iTunes/iTunes\ Music/Mobile\ Applications "${ITUNES_BACKUP_DIR}";
}

alias pg_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias flush-dns-cache='sudo killall -HUP mDNSResponder'

# Quick way to rebuild the Launch Services database and get rid of duplicates in the Open With submenu.
# via http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias rebuild-launch-services-db='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

alias now='ruby -e "puts Time.now.utc.to_i"'
alias uuid='python -c "import uuid; print uuid.uuid1()"'

# Based on http://schneems.com/post/41104255619/use-gifs-in-your-pull-request-for-good-not-evil
function convert-video-to-gif() {
  TMPFILE=$(mktemp -t gifvideo)
  echo "TMPFILE is $TMPFILE"
  echo "Converting..."
  ffmpeg -y -i "$1" -pix_fmt rgb24 -f gif "$TMPFILE"
  echo "Optimizing..."
  convert -verbose -layers Optimize "$TMPFILE" "$2"
  rm -f "$TMPFILE"
}

#########################################################################################
# Editor aliases

alias e="${EDITOR}"
alias e.="${EDITOR} ."

alias m='mate'
alias m.='mate .'

alias v='mvim'
alias v.='mvim .'

#########################################################################################
# Ruby aliases/functions

# For Rails:
alias sc='./script/console'
alias sg='./script/generate'
alias ss='./script/server'
alias sd='./script/destroy'

alias pryr="pry -r ./config/environment -r rails/console/app -r rails/console/helpers"

function heftiest {
    for file in $(find app/$1/**/*.rb -type f); do wc -l $file ; done  | sort -r | head
}

# Rubinius

alias weebuild='rake build && ./bin/mspec'

# Via mislav (https://gist.github.com/3402583)
# Shortcut interface to rbenv to quickly pick & switch between Ruby versions.
# Usage:
#   rb <version> [19]
#   rb <version> [19] <command>...
#   rb
#
# A version specifier can be a partial string which will be matched against
# available versions and the last match will be picked. The optional "19"
# argument switches JRuby or Rubinius to 1.9 mode.
#
# When no arguments are given, the current ruby version in the shell is reset
# to default.
#
# Examples:
#   rb 1.8
#   rb ree
#   rb rbx irb
#   rb rbx 19 ruby -v
#   rb jr 19 rake something
#
rb() {
  if [[ $# -lt 1 ]]; then
    rbenv shell --unset
    # warning: potentially destructive to user's environment
    unset RBXOPT
    unset JRUBY_OPTS
  else
    local ver="$(rbenv versions --bare | grep "$1" | tail -1)"
    if [[ -z $ver ]]; then
      echo "no ruby version match found" >&2
      return 1
    else
      shift
      if [[ $1 == 19 ]]; then
        local rbx_opt="RBXOPT=-X19"
        local jrb_opt="JRUBY_OPTS=--1.9"
        shift
      fi

      if [[ $# -gt 0 ]]; then
        env RBENV_VERSION="$ver" $rbx_opt $jrb_opt "$@"
      else
        [[ -n $rbx_opt || -n $jrb_opt ]] && export $rbx_opt $jrb_opt
        rbenv shell "$ver"
      fi
    fi
  fi
}

#########################################################################################
# Elixir aliases/functions

function elixir () {
    if [[ -x $(which -s elixir) ]]
    then
        command elixir "$@"
    else
        ${HOME}/dev/elixir/bin/elixir "$@"
    fi
}

#########################################################################################
# Git aliases/functions

alias g='git'

#########################################################################################
# Grep stuff

# Grep in history
function greph () { history 0 | grep -i $1 }

# use colors when GNU grep with color-support
#  Execute grep --color=auto
alias grep='grep --color=auto'

#########################################################################################
# Xcode/iOS

alias ded="rm -rf ${HOME}/Library/Developer/Xcode/DerivedData"

# Via http://www.mikeash.com/pyblog/solving-simulator-bootstrap-errors.html
alias unfuckbootstrap="launchctl list | grep UIKitApplication | awk '{print \$3}' | xargs launchctl remove"

# Nicked from http://cl.ly/1k0X0L2I033J0y0Y3V3a
function wtfxcode()
{
  sudo spindump Xcode
  local xcodefile=$(ls -t /tmp/Xcode* | tail -1)
  sudo less $xcodefile
}

# Nicked from http://www.red-sweater.com/blog/2517/fixing-pngs
function fixpng ()
{
        if [[ ! -f $1 ]] ; then
                echo "Usage: fixpng <inputFiles> [outputFile]"
                return -1
        else
                local inputFile=$1
                local outputFile=$1
                if [[ -e $2 ]] ; then
                        outputFile=$2
                else
                        zmodload zsh/regex
                        local baseName=$1
                        [[ $inputFile -regex-match "^(.*).png" ]] && baseName=$match[1]
                        outputFile=$baseName-fixed.png
                fi

                echo Writing fixed PNG to $outputFile

                xcrun -sdk iphoneos pngcrush -q -revert-iphone-optimizations $inputFile $outputFile
        fi
}

# Fix a whole mess of pngs at once
function fixpngs ()
{
        if [[ ! -f $1 ]] ; then
                echo "Usage: fixpng <inputFiles> [outputFile]"
                return -1
        else
                for i in "$@"; do fixpng ./"$i"; done;
        fi
}

#########################################################################################
## Functions for displaying neat stuff in *term title

# format titles for screen and rxvt
function title() {
    # escape '%' chars in $1, make nonprintables visible
    a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")

    case $TERM in
        screen)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            print -Pn "\ek$a\e\\"      # screen title (in ^A")
            print -Pn "\e_$2   \e\\"   # screen location
            ;;
        xterm*|rxvt)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd () {
    title "zsh" "%m(%55<...<%~)"
}

# preexec is called just before any command line is executed
function preexec () {
    title "$1" "%m(%35<...<%~)"
}

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

# rbenv
eval "$(rbenv init -)"
builtin rehash
