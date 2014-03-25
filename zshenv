# Sourced on all invocations
# Should not produce output or assume a tty is present

if which rbenv > /dev/null
then
  eval "$(rbenv init -)"
elif [[ -e /usr/local/bin/rbenv ]]
then
  eval "$(/usr/local/bin/rbenv init -)"
fi
