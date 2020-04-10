#! ~/.rvm/rubies/ruby-2.1.5/bin/ruby
#
domainname = "wonderful.me"
ipprefix = "172.19"
iprprefix = "19.172"
dhcppath = "./dhcp.txt"
dnsfpath = "./#{domainname}.db"
dnsrpath = "./#{iprprefix}.db"

if File.exists?(dhcppath) then File.delete(dhcppath) end
if File.exists?(dnsfpath) then File.delete(dnsfpath) end
if File.exists?(dnsrpath) then File.delete(dnsrpath) end


dhcpfile = File.open("#{dhcppath}","w")
dnsffile =  File.open("#{dnsfpath}","w")
dnsrfile =  File.open("#{dnsrpath}","w")

y=0
while y < 256 do
  x=0
  while x < 256 do
        
	clientname="client#{y}-#{x}"
        z="00#{y}"[-3,3]+"00#{x}"[-3,3] 
	mac= "AA:AA:AA:#{z[0,2]}:#{z[2,2]}:#{z[4,2]}"
	ipaddr = "172.19.#{y}.#{x}"
	mystringdhcp = "host #{clientname} \{\n\thardware ethernet #{mac};\n\t fixed-address #{ipaddr};\n \}\n"
	dhcpfile.write(mystringdhcp)
        mystringdnsf = "#{clientname}.#{domainname}	A	#{ipaddr}\n"
	dnsffile.write(mystringdnsf)
        mystringdnsr = "#{y}.#{x} IN PTR #{clientname}.#{domainname}\n"
	dnsrfile.write(mystringdnsr)
        x += 1
        
  end
  y += 1
end

dhcpfile.close
dnsrfile.close
dnsffile.close
