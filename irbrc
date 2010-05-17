IRB.conf[:PROMPT_MODE] = :SIMPLE

require 'rubygems'


gem 'irb_rocket'
require 'irb_rocket'

# gem install hirb
require 'hirb'
Hirb.enable

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

# http://github.com/cldwalker/bond
require 'bond'
Bond.start
