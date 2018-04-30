#!/usr/bin/env ruby
#
#
#
   files = %x(ls).split(/\n/)

   files.each { |f|
     unless File.exists?("../x86_64/#{f}")
        %x(ln -s ../noarch/#{f} ../x86_64/#{f})
     end
   }

