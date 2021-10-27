#!/usr/bin/env ruby
#
require 'json'

def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end

puts "Checking #{ARGV}"
ARGV.each { |f| 
  filedata = File.read(f)

  if valid_json?(filedata) 
    puts "File #{f} contains valid JSON data"
  else 
    puts "INVALID JSON FILE #{f}"
  end
}
