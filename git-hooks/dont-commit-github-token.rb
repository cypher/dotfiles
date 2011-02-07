#!/usr/bin/ruby
# pre-commit hook

gitconfig = File.expand_path("./gitconfig")

# Basic sanity check
if File.exists?(gitconfig)
  # A better regex, if I could get it to work:
  # '\\[github\\]\\n.+\\n\\s+token = [a-z0-9]\{32\}'
  `git grep --cached --quiet --extended-regexp -e 'token = [a-z0-9]\{32\}' -- #{gitconfig}`
  if $? == 0
    warn "Are you trying to commit your GitHub token again? Aborting commit."
    exit(1) 
  end
end
