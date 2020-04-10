#!/var/home/jgreulich/.rvm/rubies/ruby-2.1.9/bin/ruby
#


ipaddress="1.2.3.4"

revadd = ipaddress.split(".")
_revadd = ((ipaddress.split("."))[0,3].reverse).join(".")

puts _revadd


