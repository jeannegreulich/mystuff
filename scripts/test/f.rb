#! /usr/bin/env ruby
#
require 'optparse'

at_exit { puts "Come back later!" }
def testit
  puts "testing it"
  sleep 2
  puts "tested"
  exit 1
end

j = "ff"
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-l", "--[no-]link", "[Do not] Link the installed OS version to the major version") do |l|
    options[:link] = l
  end
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
  opts.on("-V", "--version [STRING]", String, "Version Number") do |version|
    p version
    options[:version] = version
  end
end.parse!

y = options[:version] || j
p y
p options
p ARGV

testit
puts "sleeping for 5 secs"
sleep 5
