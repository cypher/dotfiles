# Sourced on all invocations
# Should not produce output or assume a tty is present

if type rbenv > /dev/null 2>&1
then
  eval "$(rbenv init -)"
elif [[ -e /usr/local/bin/rbenv ]]
then
  eval "$(/usr/local/bin/rbenv init -)"
fi
