# Set favourite editor
export VISUAL="mate_wait"
export EDITOR="mate_wait" # --line %d %s"
export SVN_EDITOR="mate_wait"

export RUBYOPTS="rubygems"

# Stuff in my ~
export PATH="${HOME}/bin:${PATH}"

export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LANG="en_US.UTF-8"

# -- start rip config -- #
RIPDIR=/Users/cypher/.rip
RUBYLIB="$RUBYLIB:$RIPDIR/active/lib"
PATH="$PATH:$RIPDIR/active/bin"
export RIPDIR RUBYLIB PATH
# -- end rip config -- #

export PATH="$HOME/.cargo/bin:$PATH"

[ -f ~/.bashrc ]    && . ~/.bashrc
