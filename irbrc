IRB.conf[:PROMPT_MODE] = :SIMPLE

require 'rubygems'

if RUBY_VERSION =~ /1\.8/
  require 'utility_belt'
  UtilityBelt.equip( :all, :except => %w{amazon_upload_shortcut guessmethod rails_finder_shortcut rails_verbosity_control} )
end

gem 'irb_rocket'
require 'irb_rocket'

# sudo gem install cldwalker-hirb
gem 'cldwalker-hirb'
require 'hirb'

Hirb::View.enable

# Hirb.enable :pager => false
# Hirb.enable :formatter => false

# gem install looksee
gem 'looksee'
require 'looksee/shortcuts'

# gem install sketches
gem 'sketches'
require 'sketches'
Sketches.config :editor => 'mate'

# Awesome print: http://www.rubyinside.com/awesome_print-a-new-pretty-printer-for-your-ruby-objects-3208.html
gem 'awesome_print'
require 'ap'

# Debug Print: http://github.com/niclasnilsson/dp
require 'dp'
