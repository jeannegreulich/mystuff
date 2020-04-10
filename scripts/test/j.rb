#! /usr/bin/env ruby
#
require 'optparse'

at_exit { puts "Come back later!" }
def testit(x, &block)
  puts "testing it"
  block.call( x )
  puts "tested"
  exit 1
end

#testit do |list|
#  list.each { |l|
#    puts "jeanne knows ruby #{l}"
#  }
#end

printit = proc { |n| puts "#{n}"}
enumit = proc { |n|  n.each{ |y|  puts "Enuming it #{y}" } }


p = ["well", "great", "a little"]

puts "#### calling enumit it from each"
p.each(&printit)


puts "#### calling enumit from testit"

testit(p,&enumit)
puts "sleeping for 5 secs"
sleep 5
