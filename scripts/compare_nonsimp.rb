#!/usr/bin/env ruby
#
require 'fileutils'

def load_metadata( file_path = nil )
  require 'json'
  JSON.parse( File.read('metadata.json') )
end

root_dir = File.expand_path(ARGV[0] ? ARGV[0] : '.')
modules_dir = File.join(root_dir, 'src', 'puppet', 'modules')
modules = Dir.entries(modules_dir).delete_if { |dir| dir[0] == '.' }

modules.sort.each do |project|
   project_dir = File.join(modules_dir, project)

  Dir.chdir(project_dir) do
    metadata = load_metadata
    if metadata['name'].split('-')[0] != 'simp'
      next
    end

    puts '='*80
    puts "Processing #{project}"

    debug = false
    `SIMP_RSPEC_PUPPET_FACTS_VERSION='~> 2.0' SIMP_RAKE_HELPERS_VERSION='~> 5' bundle update 2>/dev/null`
    puts `SIMP_RSPEC_PUPPET_FACTS_VERSION='~> 2.0' SIMP_RAKE_HELPERS_VERSION='~> 5' bundle exec rake pkg:create_tag_changelog`
    puts `SIMP_RSPEC_PUPPET_FACTS_VERSION='~> 2.0' SIMP_RAKE_HELPERS_VERSION='~> 5' bundle exec rake pkg:compare_latest_tag`
  end
end

assets_dir = File.join(root_dir, 'src', 'assets')

['adapter',
'environment',
'gpgkeys',
'rsync_data',
'rubygem_simp_cli',
'utils',
'simp'].each do |project|
  puts '='*80
  puts "Processing #{project}"
  project_dir = File.join(assets_dir, project)
  Dir.chdir(project_dir) do
    `SIMP_RSPEC_PUPPET_FACTS_VERSION='~> 2.0' SIMP_RAKE_HELPERS_VERSION='~> 5' bundle update 2>/dev/null`
    puts `SIMP_RSPEC_PUPPET_FACTS_VERSION='~> 2.0' SIMP_RAKE_HELPERS_VERSION='~> 5' bundle exec rake pkg:create_tag_changelog`
    puts `SIMP_RSPEC_PUPPET_FACTS_VERSION='~> 2.0' SIMP_RAKE_HELPERS_VERSION='~> 5' bundle exec rake pkg:compare_latest_tag`
  end
end

#egrep -v 'interpolation.rb:|internal vendored libraries' compare_latest_tag.out > compare_latest_tag.out.filtered
