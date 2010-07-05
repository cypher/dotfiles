# Sourced on all invocations
# Should not produce output or assume a tty is present

export RUBYOPTS="rubygems"

# Setting PATH for MacPython 2.4
if [[ -d "/Library/Frameworks/Python.framework/Versions/Current/bin" ]]
then
    PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:${PATH}"
fi

# MySQL
if [[ -d "/usr/local/mysql/bin" ]]
then
    PATH="/usr/local/mysql/bin:${PATH}"
fi

# PostgreSQL
if [[ -d "/usr/local/pgsql/bin/" ]]
then
    PATH="/usr/local/pgsql/bin/:${PATH}"
fi

# Add these paths only if they aren't present already
for p in '/usr/sbin' '/usr/bin' '/sbin' '/bin'
do
    if ! grep $p - >/dev/null 2>&1 <<< $PATH
    then
        PATH="${p}:${PATH}"
    fi
done

# Extra git scripts
if [[ -d "${HOME}/Code/git-utils" ]]
then
    PATH="${HOME}/Code/git-utils:${PATH}"
fi

# 'clj' (http://github.com/liebke/clj)
if [[ -d "${HOME}/.cljr/bin" ]]
then
    PATH="${HOME}/.cljr/bin:${PATH}"
fi

# Force these paths to be in front of all other paths
for p in "${HOME}/bin" '/usr/local/sbin' '/usr/local/bin'
do
    PATH="${p}:${PATH}"
done

export PATH

# Java Classpath

if [[ -d "${HOME}/classes/" ]]
then
    for jar in ${HOME}/classes/*.jar
    do
        CLASSPATH="${jar}:${CLASSPATH}"
    done
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
if [[ -f $(which mate) ]]; then
    export VISUAL="mate_wait"
elif [[ -f $(which mvim) ]]; then
    export VISUAL="mvim -f -c \"au VimLeave * maca hide:\""
else
    export VISUAL="vim"
fi
export EDITOR=$VISUAL
export SVN_EDITOR=$VISUAL

# -- start rip config -- #
RIPDIR="${HOME}/.rip"
RUBYLIB="$RUBYLIB:$RIPDIR/active/lib"
PATH="$PATH:$RIPDIR/active/bin"
export RIPDIR RUBYLIB PATH
# -- end rip config -- #
