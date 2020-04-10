#!/usr/bin/env ruby
##
Module A

  def foo
    puts "Module A foo"
  end
end

Module B

  def foo
    puts "Module B foo"
  end
end

Module C

include A
  def bar
    foo
  end
end

Module D
  require 'pry'
  include C
  include B

  binding.pry
  foo

end

D.new
