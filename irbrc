require 'irb/completion'
require 'irb/ext/save-history'

unless IRB.version.include?('DietRB')
  IRB.conf[:PROMPT_MODE] = :SIMPLE
else
  IRB.formatter.prompt = :simple
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

require 'rubygems'

def try_require(gem_name, lib_name = nil)
  gem gem_name
  require(lib_name || gem_name)

  yield if block_given?
rescue LoadError => e
  warn "#{__FILE__}: Could not load `#{gem_name}':\n#{e.class}: #{e.message}"
end

try_require 'irb_rocket'

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

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

def load_railsrc(path)
  load path if File.exists?(path)
end

if $0 == 'irb' && ENV['RAILS_ENV']
  load_railsrc(File.expand_path('~/.railsrc'))
  load_railsrc(File.join(Dir.pwd, '.railsrc'))
end
