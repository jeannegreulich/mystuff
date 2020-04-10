#!/usr/bin/env ruby
    data = %x(VBoxManage list hostonlyifs)
    x=data.split(/\n\n/)
    x.each { |y|
      puts "line: #{y}"
    }
