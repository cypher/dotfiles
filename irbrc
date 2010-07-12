IRB.conf[:PROMPT_MODE] = :SIMPLE

require 'rubygems'

def try_require(gem_name, lib_name = nil)
  gem gem_name
  require(lib_name || gem_name)

  yield if block_given?
rescue LoadError
  $stderr.puts ".irbrc: Could not load `#{gem_name}'"
end

try_require 'irb_rocket'

try_require 'interactive_editor'

try_require 'hirb' do
  Hirb.enable

  # Hirb.enable :pager => false
  # Hirb.enable :formatter => false
end

# Awesome print: http://www.rubyinside.com/awesome_print-a-new-pretty-printer-for-your-ruby-objects-3208.html
try_require 'awesome_print', 'ap'

# Debug Print: http://github.com/niclasnilsson/dp
try_require 'dp'

# http://github.com/cldwalker/bond
try_require 'bond' do
  Bond.start
end
