#!/usr/bin/env ruby
#
require 'json'

def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end

def get_disk_status(a)
  disk_dev = "/dev/#{a}"
  output =  %x(smartctl --json --health "#{disk_dev}")
 
  begin 
    hash_output = JSON.parse(output)
  rescue JSON::ParserError => e
    hash_output ={}
  end
  hash_output
end

disk_data = %x(lsblk -d -n -o NAME,TYPE).split("\n")
puts "#{disk_data}"
status = {}
send_status = false
disk_data.each { |line|
  disk,type = line.split(" ")
  puts "Disk = #{disk}, Type = #{type}"
  next unless type == 'disk' 
  disk_status = get_disk_status(disk) 
  status[disk] = disk_status 
  if disk_status.empty?  
     status[disk]["msg"] = "UNKNOWN - smartctl failed"
     send_status = true
  elsif disk_status.has_key?("smart_status") && disk_status["smart_status"].has_key?("passed")
     if disk_status["smart_status"]["passed"]
        status[disk]["msg"] = "OK"
     else
        send_status = true
        status[disk]["msg"] = "FAILING"
     end
  else
     status[disk]["msg"] = "UNKNOWN - smartctl did not return status"
     send_status = true
  end


}
puts "#{status}"
puts "#{send_status}"
