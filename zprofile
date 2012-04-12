# Sourced in login shells, before .zshrc

# Force these paths to be in front of all other paths
if [[ -d "${HOME}/.rbenv/bin" ]]
then
    PATH="${HOME}/.rbenv/bin:${PATH}"
fi

for p in '/usr/local/bin' '/usr/local/sbin' "${HOME}/bin"
do
    PATH="${p}:${PATH}"
done

# If we're on OS X, we want access to the `stroke` utility
if [[ -d "/Applications/Utilities/Network Utility.app/Contents/Resources/" ]]
then
    PATH="${PATH}:/Applications/Utilities/Network Utility.app/Contents/Resources/"
fi

# If we're on OS X, we want access to the `airport` utility
if [[ -d "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/" ]]
then
    PATH="${PATH}:/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/"
fi

export PATH

# Node

if [[ -d "/usr/local/lib/node_modules" ]]
then
    NODE_PATH="${NODE_PATH}:/usr/local/lib/node_modules"
fi

export NODE_PATH

# Java Classpath

if [[ -d "${HOME}/classes/" ]]
then
    for jar in ${HOME}/classes/*.jar
    do
        CLASSPATH="${jar}:${CLASSPATH}"
    done
fi

if [[ -d "$(brew --prefix clojure-contrib)" ]]
then
    CLASSPATH="${CLASSPATH}:$(brew --prefix clojure-contrib)/clojure-contrib.jar"
fi

export CLASSPATH=".:${CLASSPATH}"

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Set favourite editor
export VISUAL="vim -f"

export EDITOR=$VISUAL
export SVN_EDITOR=$VISUAL

export LESS="-R"

export CLICOLOR=1

# Rubinius
export RBXOPT="-Xagent.start -X19"

# tuned REE GC settings, via http://smartic.us/2010/10/27/tune-your-ruby-enterprise-edition-garbage-collection-settings-to-run-tests-faster/
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

# 37signals settings
# RUBY_HEAP_MIN_SLOTS=600000
# RUBY_GC_MALLOC_LIMIT=59000000
# RUBY_HEAP_FREE_MIN=100000

# Twitter settings
# RUBY_HEAP_MIN_SLOTS=500000
# RUBY_HEAP_SLOTS_INCREMENT=250000
# RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# RUBY_GC_MALLOC_LIMIT=50000000
