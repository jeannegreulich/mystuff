#!/usr/bin/env ruby
#
class HostOnlyVbox

  def initialize
    list=%x(VBoxManage list hostonlyifs).split("\n\n")
    @hostonlylist=Hash.new
    list.each { |x|
      network=x.split("\n")
      network.each { |y|
        entry=y.split(":")
        case entry[0]
        when "Name"
          @name = entry[1].strip
        when "IPAddress"
          @ipaddr = entry[1].strip
        end
      }
      @hostonlylist[@name] = @ipaddr
    }
    puts "#{@hostonlylist}"
  end

  def findnet(network)
    puts "finding network #{network}"
    @vboxnet = nil
    @hostonlylist.each {|name, ip|
      if  ip.eql? network
        @vboxnet = name
      else
        puts ip
        puts " does not equal "
        puts network
        puts "."
      end
    }
    @vboxnet
  end

  def createhostonly(network)
    newnet=%x(VBoxManage hostonlyif create)
    if ( newnet.include? "was successfully created" )
      x = newnet.split("'")
      puts "#{x} was created"
      if system("VBoxManage hostonlyif ipconfig #{x[1]} --ip #{network}")
        return x[1]
      else
        puts "Error:  Failure to configure #{x[1]} --ip #{network}"
      end
    else
      puts "Creation of network unsuccesful. #{newnet}"
    end
    return nil
  end

end

mynet=HostOnlyVbox.new
honetwork="192.168.204.1"

vb=mynet.findnet(honetwork)

if vb.nil?
  vb=mynet.createhostonly(honetwork)
  if vb.nil?
    puts "Something didnt work"
  else
    puts "Created network #{vb} "
  end
else
  puts "Your network is #{vb}"
end


