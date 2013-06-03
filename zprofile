# Sourced in login shells, before .zshrc

# Add man dirs from Homebrew:
# sudo -e /etc/manpaths.d/homebrew
# Add line "/usr/local/share/man" (Assuming /usr/local is your Homebrew prefix)

# Node

if [[ -d "/usr/local/lib/node_modules" ]]
then
    NODE_PATH="${NODE_PATH}:/usr/local/lib/node_modules"
fi

export NODE_PATH

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

export PSQL_EDITOR="vim -c ':set ft=sql'"

export LESS="-R"

export CLICOLOR=1

# Rubinius
export RBXOPT="-Xagent.start -X19"

# The initial number of heap slots as well as the minimum number of slots allocated.
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# The number of C data structures that can be allocated before the GC kicks in.
# If set too low, the GC kicks in even if there are still heap slots available.
export RUBY_GC_MALLOC_LIMIT=1000000000
# The minimum number of heap slots that should be available after the GC runs.
# If they are not available then, ruby will allocate more slots.
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
