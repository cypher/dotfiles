##############################################################################
# PATH stuff
##############################################################################

# Add man dirs from Homebrew:
# sudo -e /etc/manpaths.d/homebrew
# Add line "/usr/local/share/man" (Assuming /usr/local is your Homebrew prefix)

# PATH '/usr/local/bin'  '/usr/bin'  '/bin'  '/usr/sbin'  '/sbin'  '/opt/X11/bin'  '/u'$

# Node
if [ -d "/usr/local/lib/node_modules" ]
	set -x NODE_PATH $NODE_PATH "/usr/local/lib/node_modules"
end

# Pick up NPM-installed binaries
if [ -d "/usr/local/share/npm/bin" ]
then
    set -x PATH $PATH "/usr/local/share/npm/bin"
end

if [ -d "/usr/local/lib/python2.7/site-packages" ]
	set -x PYTHONPATH "/usr/local/lib/python2.7/site-packages" $PYTHONPATH
end

if type xcode-select > /dev/null 2>&1
	set -x XCODE (xcode-select --print-path)
	set -x PATH $PATH $XCODE/Tools
end

if [ -d "$HOME/go" ]
	set -x GOPATH "$HOME/go"
	set -x PATH $PATH $GOPATH/bin
end

# Setup PATH for interactive shell
if [ -d "$HOME/.rbenv/bin" ]
    set -x PATH "$HOME/.rbenv/bin" $PATH
end

for path in '/usr/local/sbin' '/usr/sbin' '/sbin' '/bin' '/usr/bin' '/usr/local/bin' "$HOME/bin"
	set -x PATH $path $PATH
end
# set -x PATH "$HOME/bin" $PATH

# Pick up go binaries
if [ -e "$GOPATH/bin" ]
    set -x PATH $PATH "$GOPATH/bin"
end

# If we're on OS X, we want access to the `stroke` utility
if [ -d "/Applications/Utilities/Network Utility.app/Contents/Resources" ]
    set -x PATH $PATH "/Applications/Utilities/Network Utility.app/Contents/Resources"
end

# If we're on OS X, we want access to the `airport` utility
if [ -d "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources" ]
    set -x PATH $PATH "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources"
end

# Deduplicate entries in PATH
# typeset -U PATH

# export PATH

# Set favourite editor
set --universal --export VISUAL "vim -f"
set --universal --export EDITOR $VISUAL

# export PSQL_EDITOR="vim -c ':set ft=sql'"

# export LESS="-R"

# export CLICOLOR=1

set --universal PAGER 'less'

# The initial number of heap slots as well as the minimum number of slots allocated.
# export RUBY_GC_HEAP_INIT_SLOTS=1000000
# export RUBY_HEAP_SLOTS_INCREMENT=1000000
# export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# The number of C data structures that can be allocated before the GC kicks in.
# If set too low, the GC kicks in even if there are still heap slots available.
# export RUBY_GC_MALLOC_LIMIT=1000000000
# The minimum number of heap slots that should be available after the GC runs.
# If they are not available then, ruby will allocate more slots.
# export RUBY_HEAP_FREE_MIN=500000

# 37signals settings
# RUBY_GC_HEAP_INIT_SLOTS=600000
# RUBY_GC_MALLOC_LIMIT=59000000
# RUBY_HEAP_FREE_MIN=100000

# Twitter settings
# RUBY_GC_HEAP_INIT_SLOTS=500000
# RUBY_HEAP_SLOTS_INCREMENT=250000
# RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# RUBY_GC_MALLOC_LIMIT=50000000

# Report CPU usage for commands running longer than 10 seconds
# REPORTTIME=10
#
# history:
# setopt inc_append_history   # append history list to the history file (important for multiple parallel zsh sessions!)
# setopt share_history        # import new commands from the history file also in other zsh-session
# setopt extended_history     # save each command's beginning timestamp and the duration to the history file
# setopt hist_ignore_all_dups # If a new command line being added to the history list duplicates an older one, the older command is removed from the list
# setopt hist_ignore_space    # remove command lines from the history list when the first character on the line is a space

# HISTFILE=$HOME/.zsh_history
# HISTSIZE=10000000
# SAVEHIST=10000000           # useful for setopt append_history

# setopt extended_glob        # in order to use #, ~ and ^ for filename generation
#                             # grep word *~(*.gz|*.bz|*.bz2|*.zip|*.Z) ->
#                             # -> searches for word not in compressed files
#                             # don't forget to quote '^', '~' and '#'!
# setopt notify               # report the status of backgrounds jobs immediately
# setopt hash_list_all        # Whenever a command completion is attempted, make sure
#                             # the entire command path is hashed first.
# setopt completeinword       # not just at the end
# setopt nohup                # Don't kill background jobs when shell exits
# setopt auto_pushd         # make cd push the old directory onto the directory stack.
# setopt nonomatch            # try to avoid the 'zsh: no matches found...'
# setopt nobeep               # avoid "beep"ing
# setopt pushd_ignore_dups    # don't push the same dir twice.
# setopt noglobdots           # * shouldn't match dotfiles. ever.
# setopt long_list_jobs       # List jobs in long format, display PID when suspending processes as well
# setopt mark_dirs            # Append a trailing `/' to all directory names resulting from globbing


# do we have GNU ls with color-support?
alias ls 'ls -bh -CF'
alias la 'ls -lhAF'
alias ll 'ls -lh'
alias lh 'ls -hAl'
alias l  'ls -lhF'

# Aliases '-' to 'cd -'
# alias -- - 'cd -'

# alias fuck 'sudo $(history -p \!\!)'

#########################################################################################
# Custom aliases/commands

# alias computer,="sudo"

# alias such=git
# alias very=git
# alias wow='git status --branch --short'

# Convert a picture to a favicon
# alias make-favicon="convert -colors 256 -resize 16x16 "

# Copy the working dir to the clipboard
# alias cpwd='pwd|xargs echo -n|pbcopy'

# Show current airport status:
alias apinfo '/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

alias httpdump 'sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E "Host\: .*|GET \/.*"'

# mkdir, cd into it (via http://onethingwell.org/post/586977440/mkcd-improved)
# function mkcd () {
#     mkdir -p "$*"
#     cd "$*"
# }

alias ydl youtube-dl

# If bcat (Browser cat, http://rtomayko.github.com/bcat/) is invoked as `btee', it acts like `tee(1)'
# alias btee=bcat

# sh function to murder all running processes matching a pattern
# thanks 3n: http://twitter.com/3n/status/19113206105
# function murder () {
#   ps | grep $1 | grep -v grep | awk '{print $1}' | xargs kill -9
# }

# alias dotedit="$VISUAL ~/dotfiles/"
# alias homegit="GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~ git"

# alias sha1='openssl dgst -sha1'
# alias sha256='openssl dgst -sha256'

# alias wk2png='/usr/bin/python $(which webkit2png)'

# function console {
#   if [[ $# > 0 ]]; then
#     query=$(echo "$*" | tr -s ' ' '|')
#     tail -f /var/log/system.log|grep -i --color=auto -E "$query"
#   else
#     tail -f /var/log/system.log
#   fi
# }

# function backup-itunes() {
#   printf "Backing up Music and Audiobooks\n"
#   rsync --update --human-readable --recursive --progress --inplace --8-bit-output ~/Music/iTunes/iTunes\ Music/{Music,Audiobooks} "${ITUNES_BACKUP_DIR}";
#   printf "Backing up iOS Apps\n"
#   rsync --update --human-readable --recursive --progress --inplace --8-bit-output --delete-after ~/Music/iTunes/iTunes\ Music/Mobile\ Applications "${ITUNES_BACKUP_DIR}";
# }

# alias pg_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
# alias pg_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# alias flush-dns-cache='sudo killall -HUP mDNSResponder'

# Quick way to rebuild the Launch Services database and get rid of duplicates in the Open With submenu.
# via http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
# alias rebuild-launch-services-db='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# alias now='ruby -e "puts Time.now.utc.to_i"'
# alias uuid='python -c "import uuid; print uuid.uuid1()"'

# Based on http://schneems.com/post/41104255619/use-gifs-in-your-pull-request-for-good-not-evil
# function convert-video-to-gif() {
#   TMPFILE=$(mktemp -t gifvideo)
#   echo "TMPFILE is $TMPFILE"
#   echo "Converting..."
#   ffmpeg -y -i "$1" -pix_fmt rgb24 -f gif "$TMPFILE"
#   echo "Optimizing..."
#   convert -verbose -layers Optimize "$TMPFILE" "$2"
#   rm -f "$TMPFILE"
# }

# 'work on', via https://coderwall.com/p/feoi0a
# function wo() {
#   cd $(find $CODE_DIR -type d -maxdepth 3 | grep -i $* | grep -Ev Pods --max-count=1)
# }

# function dash() {
#   open "dash://$1"
# }

# `wifi on` to turn wifi on, and `wifi off` to turn it off
# alias wifi="networksetup -setairportpower $(networksetup -listallhardwareports | grep -A 2 'Hardware Port: Wi-Fi' | grep 'Device:' | awk '{print $2}')"

#########################################################################################
# Editor aliases

# alias e="${EDITOR}"
# alias e.="${EDITOR} ."

# alias m='mate'
# alias m.='mate .'

# alias v='mvim'
# alias v.='mvim .'

#########################################################################################
# Ruby aliases/functions

# Bundler:
# alias be='bundle exec'

# For Rails:
# alias sc='./script/console'
# alias sg='./script/generate'
# alias ss='./script/server'
# alias sd='./script/destroy'

# alias pryr="pry -r ./config/environment -r rails/console/app -r rails/console/helpers"

# function heftiest {
#     for file in $(find app/$1/**/*.rb -type f); do wc -l $file ; done  | sort -r | head
# }

# Rubinius

# alias weebuild='rake build && ./bin/mspec'

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
# rb() {
#   if [[ $# -lt 1 ]]; then
#     rbenv shell --unset
#     # warning: potentially destructive to user's environment
#     unset RBXOPT
#     unset JRUBY_OPTS
#   else
#     local ver="$(rbenv versions --bare | grep "$1" | tail -1)"
#     if [[ -z $ver ]]; then
#       echo "no ruby version match found" >&2
#       return 1
#     else
#       shift
#       if [[ $1 == 19 ]]; then
#         local rbx_opt="RBXOPT=-X19"
#         local jrb_opt="JRUBY_OPTS=--1.9"
#         shift
#       fi
#
#       if [[ $# -gt 0 ]]; then
#         env RBENV_VERSION="$ver" $rbx_opt $jrb_opt "$@"
#       else
#         [[ -n $rbx_opt || -n $jrb_opt ]] && export $rbx_opt $jrb_opt
#         rbenv shell "$ver"
#       fi
#     fi
#   fi
# }

# common_gems=(irb_rocket hirb awesome_print dp bundler thor awesome_print wirble foreman rblineprof guard guard-shell rb-fsevent pry pry-doc pry-debugger pry-exception_explorer pry-stack_explorer warbler terminal-notifier)

# function install-common-gems() {
#   gem update --system
#   for gem_name in $standard_gems; do
#     gem install --no-document "$gem_name"
#   done
#   rbenv rehash
# }

# function julia() {
#   /Applications/Julia-*.app/Contents/Resources/julia/bin/julia $*
# }

# function asmdoc() {
#   sqlite3 ~/.x86-64.sqlite "$(echo -e "SELECT description FROM instructions WHERE mnem=UPPER('$1')")" | $PAGER
# }

# If @radareorg is installed:
# function asmdoc() {
#   r2 -c "?d $@" -q --
# }

##############################################################################
# Git aliases/functions/stuff
##############################################################################

alias g 'git'

# mkdir .git/safe in the root of repositories you trust
# export PATH=".git/safe/../../bin:$PATH"

##############################################################################
# Grep stuff
##############################################################################

# Grep in history
# function greph () { history 0 | grep -i $1 }

# use colors when GNU grep with color-support
#  Execute grep --color=auto
# alias grep='grep --color=auto'

##############################################################################
# Xcode/iOS
##############################################################################

# alias ded="rm -rf ${HOME}/Library/Developer/Xcode/DerivedData"

# Via http://www.mikeash.com/pyblog/solving-simulator-bootstrap-errors.html
# alias unfuckbootstrap="launchctl list | grep UIKitApplication | awk '{print \$3}' | xargs launchctl remove"

# Nicked from http://cl.ly/1k0X0L2I033J0y0Y3V3a
# function wtfxcode()
# {
#   sudo spindump Xcode
#   local xcodefile=$(ls -t /tmp/Xcode* | tail -1)
#   sudo less $xcodefile
# }

# Nicked from http://www.red-sweater.com/blog/2517/fixing-pngs
# function fixpng ()
# {
#         if [[ ! -f $1 ]] ; then
#                 echo "Usage: fixpng <inputFiles> [outputFile]"
#                 return -1
#         else
#                 local inputFile=$1
#                 local outputFile=$1
#                 if [[ -e $2 ]] ; then
#                         outputFile=$2
#                 else
#                         zmodload zsh/regex
#                         local baseName=$1
#                         [[ $inputFile -regex-match "^(.*).png" ]] && baseName=$match[1]
#                         outputFile=$baseName-fixed.png
#                 fi
#
#                 echo Writing fixed PNG to $outputFile
#
#                 xcrun -sdk iphoneos pngcrush -q -revert-iphone-optimizations $inputFile $outputFile
#         fi
# }

# Fix a whole mess of pngs at once
# function fixpngs ()
# {
#         if [[ ! -f $1 ]] ; then
#                 echo "Usage: fixpng <inputFiles> [outputFile]"
#                 return -1
#         else
#                 for i in "$@"; do fixpng ./"$i"; done;
#         fi
# }

##############################################################################
# Functions for displaying neat stuff in *term title
##############################################################################

# format titles for screen and rxvt
# function title() {
#     # escape '%' chars in $1, make nonprintables visible
#     a=${(V)1//\%/\%\%}
#
#     # Truncate command, and join lines.
#     a=$(print -Pn "%40>...>$a" | tr -d "\n")
#
#     case $TERM in
#         screen)
#             print -Pn "\e]2;$a @ $2\a" # plain xterm title
#             print -Pn "\ek$a\e\\"      # screen title (in ^A")
#             print -Pn "\e_$2   \e\\"   # screen location
#             ;;
#         xterm*|rxvt)
#             print -Pn "\e]2;$a @ $2\a" # plain xterm title
#             ;;
#     esac
# }

# precmd is called just before the prompt is printed
# function precmd () {
#     title "zsh" "%m(%55<...<%~)"
# }

# preexec is called just before any command line is executed
# function preexec () {
#     title "$1" "%m(%35<...<%~)"
# }

##############################################################################
# rbenv
##############################################################################

# builtin rehash
if which rbenv > /dev/null 2>&1
	set PATH $HOME/.rbenv/bin $PATH
	set PATH $HOME/.rbenv/shims $PATH
	# rbenv rehash
end

##############################################################################
# Local Config
##############################################################################

# use .localrc for settings specific to one system
# [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local