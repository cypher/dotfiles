function update-dotfiles --description "Updates the dotfiles"
# cd ~/dotfiles; git stash && git reup && git submodule update --init && git stash pop; printf "\n" && gem up && printf "\n" && gem cleanup; print "\n" && (cd ~/.rbenv/plugins/ruby-build; git up); (cd ~/Mjam/mjam-ios; git up); (cd ~/Mjam/mjam-android; g up); (cd ~/Mjam/django; g up); (cd ~/src/freebsd; g up); terminal-notifier -message "Finished upgrading dotfiles, Rubygems and repos" -title "Update finished"

  cd ~/dotfiles

  git stash; and git reup; and git submodule update --init; and git stash pop

  echo -e "\n"

  gem up; and echo -e "\n"; and gem cleanup

  echo -e "\n"

  # Fish does not yet support subshells
  echo -e "Updating ruby-build..."
  fish -c 'cd ~/.rbenv/plugins/ruby-build; and git up'
  echo -e "\n\nUpdating mjam-ios..."
  fish -c 'cd ~/Mjam/mjam-ios; and git up'
  echo -e "\n\nUpdating mjam-android..."
  fish -c 'cd ~/Mjam/mjam-android; and git up'
  echo -e "\n\nUpdating django..."
  fish -c 'cd ~/Mjam/django; and git up'
  echo -e "\n\nUpdating FreeBSD"
  fish -c 'cd ~/src/freebsd; and git up'

  terminal-notifier -message "Finished upgrading dotfiles, Rubygems and repos" -title "Update finished"\n
end
