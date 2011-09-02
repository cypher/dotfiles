# Sourced on all invocations
# Should not produce output or assume a tty is present

# Setting PATH for MacPython 2.4
if [[ -d "/Library/Frameworks/Python.framework/Versions/Current/bin" ]]
then
    PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:${PATH}"
fi

# # Add these paths only if they aren't present already
# for p in '/usr/sbin' '/usr/bin' '/sbin' '/bin'
# do
#     if ! grep $p - >/dev/null 2>&1 <<< ${PATH}
#     then
#         PATH="${PATH}:${p}"
#     fi
# done

# Force these paths to be in front of all other paths
for p in '/usr/local/bin' '/usr/local/sbin' "${HOME}/bin"
do
    PATH="${p}:${PATH}"
done

if [[ -d "${HOME}/.rbenv/shims" ]]
then
    PATH="${HOME}/.rbenv/shims:${HOME}/.rbenv/bin:${PATH}"
fi

export PATH

# Node

if [[ -d "/usr/local/lib/node" ]]
then
    NODE_PATH="/usr/local/lib/node:${NODE_PATH}"
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

if whence brew > /dev/null && brew installed | grep --silent clojure-contrib
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

# Required for MacPorts
export DISPLAY=:0.0

# Set favourite editor
# if [[ -f $(which mate) ]]; then
#     export VISUAL="mate_wait"
if [[ -f $(which mvim) ]]; then
    export VISUAL=mvim_visual
else
    export VISUAL="vim -f"
fi

export EDITOR=$VISUAL
export SVN_EDITOR=$VISUAL

export LESS="-R"

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

