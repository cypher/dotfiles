IRB.conf[:PROMPT_MODE] = :SIMPLE

require 'rubygems'

begin
  gem 'irb_rocket'
  require 'irb_rocket'
rescue LoadError
  # This gem requires a native extension, so it fails to load under JRuby
end

# gem install interactive_editor
# Supersedes the Utiltity Belt version
gem 'interactive_editor'
require 'interactive_editor'

# gem install hirb
require 'hirb'
Hirb.enable

# Hirb.enable :pager => false
# Hirb.enable :formatter => false

# Awesome print: http://www.rubyinside.com/awesome_print-a-new-pretty-printer-for-your-ruby-objects-3208.html
gem 'awesome_print'
require 'ap'

# Debug Print: http://github.com/niclasnilsson/dp
require 'dp'

begin
  # http://github.com/cldwalker/bond
  require 'bond'
  Bond.start
rescue LoadError
  # This gem requires a native extension, so it fails to load under JRuby
end

