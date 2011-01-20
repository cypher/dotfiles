#!/usr/bin/env ruby
#
# Released under MIT License
# Copyright (c) 2009 Markus Prinz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'shellwords'

# Update Java Classpath
CLASSPATH = ENV["CLASSPATH"] ? ENV["CLASSPATH"].split(':') : []

custom_classes_path = File.expand_path("~/classes")

Dir[File.join(custom_classes_path, "*.jar")].each do |jar|
  CLASSPATH << jar unless CLASSPATH.include?(jar)
end if File.exists?(custom_classes_path)

# Add penumbra (OpenGL bindings) if found
PENUMBRA_DIR = File.expand_path("~/Code/penumbra")
penumbra_available = false

# Deactivated for now
if File.exists?(PENUMBRA_DIR)
  Dir[File.join(PENUMBRA_DIR, 'lib', 'osx', '*.jar')].each do |jar|
    CLASSPATH << jar unless CLASSPATH.include?(jar)
  end

  CLASSPATH << File.join(PENUMBRA_DIR, 'src')
end

CLOJURE_DIR = File.expand_path("~/Code/clojure")
CLOJURE_JAR = File.join(CLOJURE_DIR, "clojure.jar")
CLOJURE_CONTRIB_DIR = File.expand_path("~/Code/clojure-contrib")
CLOJURE_CONTRIB_JAR = File.join(CLOJURE_CONTRIB_DIR, "clojure-contrib.jar")

run_clojure = "java "
run_clojure << "-Djava.library.path=#{File.join(PENUMBRA_DIR, 'lib', 'osx')} "
run_clojure << "-cp #{CLOJURE_JAR}:#{CLOJURE_CONTRIB_JAR}:#{CLASSPATH.join(":")}:. "

if ARGV.empty?
  run_repl = ""
  run_repl << run_clojure
  run_repl << "jline.ConsoleRunner " if CLASSPATH.find{ |jar| jar =~ /jline-\d+\.\d+\.\d+\.jar/ }
  run_repl << "clojure.main --repl"

  exec run_repl
else
  exec "#{run_clojure} -server clojure.main #{ARGV[0]} -- #{ARGV[1..-1].shelljoin}"
end
