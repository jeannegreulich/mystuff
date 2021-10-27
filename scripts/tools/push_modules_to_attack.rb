#!/usr/bin/env ruby
#
require 'fileutils'
require 'json'
require 'optparse'

=begin
output should be
|component | version in proposed | version in last | last released version,| URL to changelog on master |
|          | puppetfile proposed | SIMP release    | latest version        |                            |
=end

# parts lifted from simp-rake-helpers R10KHelper
class PuppetfileHelper
  attr_accessor :puppetfile
  attr_accessor :modules
  attr_accessor :basedir

  require 'r10k/puppetfile'

  def initialize(puppetfile)
    @modules = []
    @basedir = File.dirname(File.expand_path(puppetfile))

    puts "#{@basedir}"
    Dir.chdir(@basedir) do

      R10K::Git::Cache.settings[:cache_root] = File.join(@basedir,'.r10k_cache')
      FileUtils.mkdir_p(R10K::Git::Cache.settings[:cache_root])

      r10k = R10K::Puppetfile.new(Dir.pwd, nil, puppetfile_name=puppetfile)
      r10k.load!

      puts "#{r10k.desired_contents}"

      @modules = r10k.modules.collect do |mod|
        mod = {
          :name        => mod.name,
          :path        => mod.path.to_s,
          :repo      => mod.repo,
          :remote      => mod.repo.instance_variable_get('@remote'),
          :desired_ref => mod.desired_ref,
          :git_source  => mod.repo.repo.origin,
          :git_ref     => mod.repo.head,
          :module_dir  => mod.basedir,
          :r10k_module => mod
        }
      end
    end
  end

  def each_module(&block)
    Dir.chdir(@basedir) do
      @modules.each do |mod|
        block.call(mod)
      end
    end
  end

end


####################################
#if __FILE__ == $0
#  reporter = ComponentStatusGenerator.new
#  exit reporter.run(ARGV)
#end
pf = PuppetfileHelper.new("Puppetfile")

pf.each_module { |m| 
  puts "#{m[:name]} \n"
  puts "\tPATH  #{m[:path]}\n"
  puts "\tREPO #{m[:repo].to_s} \n"
  puts "\tREMOTE #{m[:remote].to_s} \n"
  puts "\tDESIRED_REF  #{m[:desired_ref]}\n"
  puts "\tGIT SOURCE #{m[:git_source].to_s}\n"
  puts "\tMODULE DIR #{m[:module_dir].to_s}\n"
}

