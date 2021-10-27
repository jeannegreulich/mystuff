#!/usr/bin/env ruby
#

require 'fileutils'
require 'json'
require 'optparse'

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

      #puts "#{r10k.desired_contents}"

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



class Puppetfile

  def initialize(puppetfile)
    file = File.open(puppetfile)
    @filedata = file.read.split("\n")
  end

  def print
    puts @filedata
  end

end

class SimpModule

  require 'git'

  def initialize(modulename = "simp-core", repo = nil, github = "https://github.com/simp/", branch = "master" , moduledir = @@workingdir )
    if repo.nil?
      @name = "#{modulename}"
    else
      @name = repo.split('/').last
    end
    @branch = branch
    @mydir = File.join(moduledir, modulename)
    @repo = repo || "#{github}#{modulename}"
    begin
      @g = Git.clone(@repo, modulename, :path => moduledir )
    rescue Exception => e
      puts "Failed to clone  #{modulename}"
      puts "Error => #{e}"
      @g = nil
      raise
    end
    if @g.is_branch?(@branch)
      @g.branch(@branch).checkout
    else
      raise StandardError.new "Module \"#{modulename}\" does not have branch \"#{branch}\""
    end

  end

  def puppetfile(name="Puppetfile.pinned")
    if File.exists?("#{@mydir}/#{name}")
      "#{@mydir}/Puppetfile.pinned"
    else
      "error"
    end
  end

  def add_remote(remote = 'gitlab.tasty.bacon/simp/attack-of-the-clones',
                 user = 'jgreulich',
                 token = '/home/jgreulich/.ssh/tokens/AOC-api',
                 rname = "AOC")
    require 'pathname'

     if (Pathname.new token).absolute?
       if File.exists?(token)
        _token = File.read(token).chomp
       else
        return 1
        raise StandardError.new "File #{token} does not exist"
       end
     else
      _token = token
     end

    url = "https://#{user}:#{_token}@#{remote}/#{@name}"
    begin
      @g.add_remote(name = rname, remote = url)
      return rname
    rescue Exception => e
      puts "\t Error:  Failed to add remote #{rname} with url #{url}"
      puts "\t\t Error Message => #{e}"
      return nil
    end
  end

  def push_to_remote(rname)
    if @g.nil?
      puts "\t Error: module #{@name} not cloned properly"
      return 1
    else
      begin
        @g.push(remote = rname, branch = @branch)
        puts "\t Push to remote #{rname} succeeded for #{@name} reference #{@branch}."
      rescue  Exception => e
        puts "\t Error: module: #{@name} Failed to push to remote #{rname}"
        return 1
      end
    end
  end
end

@@workingdir = Dir.mktmpdir
justprint = false

# Get the Puppet file from  simp-core
#require 'pry'
#binding.pry
sc = SimpModule.new(modulename='simp-core')
puppetfile = sc.puppetfile
puts "Using Puppetfile: #{puppetfile}"
pf = PuppetfileHelper.new("#{puppetfile}")
rname = sc.add_remote
sc.push_to_remote(rname)

puts "Adding remote failed." if rname.nil? && exit

pf.each_module { |m|
  if justprint 
    puts "#{m[:name]} \n"
    puts "\tPATH  #{m[:path]}\n"
    puts "\tREPO #{m[:repo].to_s} \n"
    puts "\tREMOTE #{m[:remote].to_s} \n"
    puts "\tDESIRED_REF  #{m[:desired_ref]}\n"
    puts "\tGIT SOURCE #{m[:git_source].to_s}\n"
    puts "\tMODULE DIR #{m[:module_dir].to_s}\n"
  else

    if m[:remote].to_s.end_with?("pupmod-simp-#{m[:name]}")
      puts "-------------- Start Processing #{m[:name]} ---------------------------\n"
      gitclone = SimpModule.new( modulename = m[:name], repo = m[:remote].to_s, moduledir = m[:module_dir].to_s, branch = 'master')
      puts "\t Clone of module failed" if gitclone.nil? && next
      rname = gitclone.add_remote
      puts "\t Adding remote failed." if rname.nil? && next
      gitclone.push_to_remote(rname)
      puts "-------------- End Processing #{m[:name]} ---------------------------\n"
    else
      puts "\nSkipping module #{m[:name]} \n"
    end
  end

}
