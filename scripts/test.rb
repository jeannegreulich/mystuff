#!/usr/bin/env ruby
#

require 'yaml'
def get_status(settings)
   status = Hash.new
   ['ownerAuthset','endorsementAuthSet','lockoutAuthSet','disableClear','inLockout','tpmGeneratedEPS'].each {|l|
     x = 'unknown'
     if settings.has_key?(l)
       case settings[l]
       when 'clear'
         x = false
       when 'set'
         x = true
       end
     end
     status[l] = x
   }
   status
end
def trans_props(props)

  {
    'status' => get_status(props['TPM_PT_PERSISTENT']),
    'tpm_getcap' => { 'properties_variable' => props }
  }
end

    require 'pry'
    binding.pry
props = YAML.load_file('./test.yaml')
result = trans_props(props)

puts result


