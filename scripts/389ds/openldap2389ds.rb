#!/usr/bin/env ruby
#
require 'fileutils'
require 'net-ldap'

def convert_group(dn,attr)
  newattr =  {}
  puts "Group LDIF #{dn}"
  newdn = dn.gsub(@oldgroupdn,@newgroupdn)
  attr.each do |a,v|
    newattr[a] = v unless @delete_keys.member?(a)
  end
  @ldifs_389[newdn] = newattr
end

def convert_user(dn,attr)
   newattr = {}
   attr.each do |a,v|
     case a
     when :sshpublickey
        newattr[:nssshpublickey] = v
     when :objectclass
       newv = ['nsAccount']
       v.each do |nv|
         case v
         when 'ldapPublicKey'
           # no op drop this class
         else
           newv << nv
         end
       end
       newattr[:objectclass] = newv
     else
       newattr[a] = v unless @delete_keys.include?(a)
     end
  end
  @ldifs_389[dn] = newattr
end


@delete_keys = [:entryUUID, :entryuuid, :entryCSN,  :entrycsn, :pwdChangedTime, :pwdchangetime]
@ldifs_389 = {}
@basedn = 'dc=tasty,dc=bacon'
@oldgroupdn = "ou=Group,#{@basedn}"
@olduserdn = "ou=People,#{@basedn}"
@newgroupdn ="ou=Groups,#{@basedn}"

text = File.open("./tasty.ldif", "r")

ldifs = Net::LDAP::Dataset.read_ldif(text)
#puts "LDIFS: #{ldifs}"
text.close

ldifs.each do |dn, attr|
  if dn.end_with?(@oldgroupdn)
    convert_group(dn,attr)
  elsif  dn.end_with?(@olduserdn)
    convert_user(dn,attr)
  else
    puts "Not converting #{dn}"
  end
end

newtext = File.open("./jmgtasty.ldif", 'w')
@ldifs_389.each do |k,v|
  newtext.write "dn=#{k}\n"
  v.each do |x,y|
    newtext.write "#{x} = #{y}\n"
  end
end
newtext.close

newtext = File.open("./tasty_new.ldif", 'w')
ds = Net::LDAP::Dataset.new
obj = ds.to_entries(@myhash)

newtext.write(Net::LDAP::Dataset.to_ldif_string(@myhash))
newtext.close
