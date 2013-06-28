def write_backtrace name, backtrace, filename
  exceptions = Regexp.union([
    /\.bundle/,
    /spec/,
    /test/,
    /lib\/ruby\/1.9.1/
  ])

  backtrace.reject! { |line| line =~ exceptions }

  File.open(filename, 'a') do |f|
    f.write "* #{name}\n\n" + backtrace.join("\n") + "\n\n"
  end
end

# Example usage:
#
#   trace Redis::Client#process my_redis_calls.log
#
Pry.commands.block_command(/trace ([^ ]+) ([^ ]+)$/, "Trace a method invocation and log it to a file", :listing => "trace") do |bp, filename|
  run "breakpoint #{bp} if (write_backtrace(%{#{bp}}, caller, %{#{filename}}); false)"
  run "continue"
end
