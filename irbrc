require 'rubygems'
require 'ap'
require 'dp'

begin
  require 'irb/completion'
rescue Exception => e
  warn "Failed to load 'irb/completion': #{e}"
end

begin
  require 'irb/ext/save-history'
  IRB.conf[:SAVE_HISTORY] = 300
  IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
rescue LoadError => e
  warn "Failed to load 'irb/ext/save-history': #{e}"
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
