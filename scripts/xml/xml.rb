#!/usr/bin/env ruby
#

require 'rexml/document'
include REXML

iso_file = File.new('/home/jgreulich/transfer/iso_repomd.xml')
iso_doc = Document.new(iso_file)

dvd_file = File.new('/home/jgreulich/transfer/dvd_repomd.xml')
dvd_doc = Document.new(dvd_file)

dvdroot = dvd_doc.root

dvdroot.children_each children}"
#dvdroot.add "data", { 'type' => 'group'}

outputfile = File.open('/home/jgreulich/transfer/dvd_repomd2.xml', "w+")
dvd_doc.write(:output => outputfile)

puts "--------------------------"
dvd_doc.elements.each("repomd/data") {|e| 
  puts "DVD Elements #{e}"

}

#xml_doc.elements.each do |e|
#  puts " Elements #{e}"
#end
