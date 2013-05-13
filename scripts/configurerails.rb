#!/usr/bin/env ruby
# Configures a rails application for development/production
# see http://blog.kingstontam.com/2011/06/07/setting-up-a-rails-app/
require 'fileutils'
require 'SecureRandom'
require 'optparse'
require 'net/http'
include FileUtils

# Boilerplate

options = {}
optparser = OptionParser.new do |opts|
  opts.banner = "usage: configurerails.rb [options]"

  opts.on("-p", "--production", "Sets the app up for production") do |b|
    options[:production] = b
  end
end

optparser.parse!

def error(error)
  puts error
  exit 1
end

def safesystem(command)
  puts "---"
  output = `#{command}`
  puts output
  error("Error running command: " + command) unless $?.exitstatus == 0
  puts "---"
  return output
end

puts "Installing gems..."

safesystem "bundle install"

if File.exists? "config/database.template.yml" and not File.exists? "config/database.yml"
  puts "Loading database.yml..."

  cp "config/database.template.yml", "config/database.yml"
end

if File.exists? "config/settings.local.template.yml" and not File.exists? "config/settings.local.yml"
  puts "Loading settings.local.yml"

  cp "config/settings.local.template.yml", "config/settings.local.yml"

  File.open("config/settings.local.yml", "w") do |f|
    f.puts File.read("config/settings.local.template.yml").sub("secret_token: ~", "secret_token: '" + SecureRandom.hex(128) + "'")
  end
end

if options[:production]
  puts "Compiling assets..."
  safesystem "rake RAILS_ENV=production assets:precompile"

  puts "Migrating database..."
  safesystem "rake RAILS_ENV=production db:migrate"
else
  puts "Migrating database..."
  safesystem "rake db:migrate"
end

puts "Be sure to replace any local settings with the appropriate settings..."
