#!/usr/bin/env ruby
#
require 'fileutils'

def get_act_svc
  active_services = Array.new

  %x{systemctl list-unit-files -t service}.split("\n").each do |x|
    if x =~ /\.service/
      service,state = x.split(/\s+/)
      state.strip!
      next if state == 'static'
      next if service.include?('@')
      active_services << service.strip
    end
  end
  active_services
end

def sys_aliases(svcs)
     sys_alias = Array.new

       svcs.each do |svc|
        begin
          # Collect all active service names and aliases
          svc_entries = (%x{systemctl show -p Names #{svc}}).split('=').last.split(/\s+/)
          # If name returns more than one service entry, the service has an alias
          if svc_entries.count > 1
            sys_alias << svc_entries
          end

        # Service units cannot always be found. Skip them if they can't.
        rescue Exception => e
          Puppet.debug("svckill: #{e.message}")
          next
        end
      end
      sys_alias.flatten!
      sys_alias.uniq!
end
a_svc = Array.new
a_svc = get_act_svc
puts ""
puts "---------------"
puts "Active services #{a_svc}"
systemd_aliases = sys_aliases(a_svc)
puts ""
puts "---------------"
puts "systemd aliases: #{systemd_aliases}"

