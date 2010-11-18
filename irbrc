unless IRB.version.include?('DietRB')
  IRB.conf[:PROMPT_MODE] = :SIMPLE
else
  IRB.formatter.prompt = :simple
end

require 'rubygems'

def try_require(gem_name, lib_name = nil)
  gem gem_name
  require(lib_name || gem_name)

  yield if block_given?
rescue LoadError
  $stderr.puts "#{__FILE__}: Could not load `#{gem_name}'"
end

try_require 'irb_rocket'

try_require 'interactive_editor'

# MacRuby/DietRB doesn't like Hirb, so don't load it
unless IRB.version.include?('DietRB')
  try_require 'hirb' do
    Hirb.enable

    # Hirb.enable :pager => false
    # Hirb.enable :formatter => false
  end
end

# Awesome print: http://www.rubyinside.com/awesome_print-a-new-pretty-printer-for-your-ruby-objects-3208.html
try_require 'awesome_print', 'ap' do
  unless IRB.version.include?('DietRB')
    IRB::Irb.class_eval do
      def output_value
        ap @context.last_value
      end
    end
  else # MacRuby
    IRB.formatter = Class.new(IRB::Formatter) do
      def inspect_object(object)
        object.ai
      end
    end.new
  end
end

# Debug Print: http://github.com/niclasnilsson/dp
try_require 'dp'

# http://github.com/cldwalker/bond
try_require 'bond' do
  Bond.start
end
