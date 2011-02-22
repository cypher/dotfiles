#!/usr/bin/env ruby

require 'shellwords'

modified_files = `git ls-files --modified`.split("\n")

if modified_files.any?
  modified_files = modified_files.map(&:shellescape).join(' ')

  unless `egrep -rls "^<<<<<<< |^>>>>>>> |^=======$" #{modified_files} | xargs file | egrep 'script|text'`.chomp.empty?
    warn "There are still merge markers left!"

    system %Q{egrep -rls "^<<<<<<< |^>>>>>>> |^=======$" #{modified_files} | xargs file | egrep 'script|text' | awk -F: '{print $1}'}

    exit 1
  end
end
