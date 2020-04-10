#!/usr/bin/env ruby
#
class Puppetfile

  def initialize(puppetfile)
    file = File.open(puppetfile)
    @filedata = file.read.split("\n")
  end

  def print
    puts @filedata
  end

end

class SimpCore

  require 'git'

  def initialize(modulename = "https://github.com/simp/simp-core", branch = "master" )
    @workingdir = Dir.mktmpdir
    @name = modulename
    @branch = branch
  end

  def clone
    cmd = "git clone --depth 1 --branch #{@branch} #{@name} #{@workingdir}"
    %x(git clone --depth 1 --branch "#{@branch}" "#{@name}" "#{@workingdir}")
  end

  def puppetfile
    if File.exists?("#{@workingdir}/Puppetfile.pinned")
      "#{@workingdir}/Puppetfile.pinned"
    else
      "error"
    end
  end
end

sc = SimpCore.new
sc.clone
puppetfile = sc.puppetfile
puts #{puppetfile}
pf=Puppetfile.new("#{puppetfile}")
pf.print



