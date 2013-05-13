#!/usr/bin/env ruby
# Creates and sets up a new rails app
# see http://blog.kingstontam.com/2011/06/07/setting-up-a-rails-app/
require 'fileutils'
require 'SecureRandom'
require 'optparse'
require 'net/http'
include FileUtils

# Boilerplate

options = {}
optparser = OptionParser.new do |opts|
  opts.banner = "usage: railssetup.rb appname [options]"

  opts.on("-b", "--[no-]bourbon", "Install bourbon gem") do |b|
    options[:bourbon] = b
  end
end

optparser.parse!

if ARGV.count == 0 or not ARGV[0] =~ /[a-zA-Z0-9]+/
  puts optparser
  exit 64
end

appname = ARGV[0]

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

def addGem(gem, bundle = true)
  gemfileText = File.read("Gemfile")
  searchText = "gem 'sqlite3'"
  idx = gemfileText.index(searchText) + searchText.length
  error("Unable to find reference sqlite3 gem in Gemfile") unless idx

  versionInfo = safesystem "gem list " + gem + " -r"

  match = versionInfo.match /#{gem} \(([0-9\.]+)\)/

  error("Unable to retrieve version number of gem " + gem) if match == nil or match[1] == nil

  version = match[1]

  newText = gemfileText.insert idx, "\ngem '" + gem + "', '~> " + version + "'"
  File.open("Gemfile", 'w') { |f| f.write(newText) }

  safesystem "bundle install" if bundle
end

# Update Rails Gem
# ================

puts "Updating rails gem..."

safesystem "gem update rails"

appname = ARGV[0]

# Create Rails app
# ================

error("Existing file/directory called " + appname + " already exists!") if File.exists? appname

puts "Generating rails app..."

safesystem 'rails new ' + appname

cd appname

# Move and ignore database.yml
# ============================

puts "Moving and ignoring database.yml..."

cp "config/database.yml", "config/database.template.yml"
File.open(".gitignore", "a") do |f|
  f.puts ""
  f.puts "# Ignore database.yml file"
  f.puts "config/database.yml"
end

# Ignore public/assets
# ====================

File.open(".gitignore", "a") do |f|
  f.puts ""
  f.puts "# Ignore precompiled assets"
  f.puts "public/assets"
end

# Create README.md file
# =====================

puts "Creating readme file..."

File.open("README.md", "w") do |f|
  f.puts appname.capitalize
  f.puts "=" * appname.length
  f.puts ""
  f.puts "A brand new sweet Rails app :)"
end

# Place initial commit
# ====================

puts "Initializing git..."

safesystem "git init"
safesystem "git add ."
safesystem "git commit -m 'Initial commit'"

# Install rails-config gem
puts "Installing rails_config..."

addGem 'rails_config'

safesystem "rails g rails_config:install"

#rm "config/initializers/rails_config.rb"

File.open("config/initializers/rails_config.rb", "a") do |f|
  f.puts <<EOS


# Checks for the presence of database.yml
if !File.exist?("\#{Rails.root}/config/database.yml")
  abort "ERROR: database.yml missing.  Please copy config/database.template.yml to config/database.yml and configure it for your machine."
end
 
# Check for a local.yml file
if !File.exist?("\#{Rails.root}/config/settings.local.yml")
  abort "ERROR: local.yml missing.  Please copy config/settings.local.template.yml to config/settings.local.yml and configure it for your machine."
end
EOS
end

File.open("config/initializers/secret_token.rb", "w") do |f|
  f.puts <<EOS
# Be sure to restart your server when you modify this file.
 
# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
secret_token = Settings.secret_token
abort "ERROR: No secret token provided.  Please assign a random secret_token to local.yml." if secret_token.blank?
Rails.application.config.secret_token = secret_token
EOS
end

localSettings = <<EOS
# Version: 1
# Contains local settings that must be modified for each machine
 
# IMPORTANT: You need to copy the contents of this file to local.yml and customize accordingly
 
# Replace with something very random and very long (min 30 chars)
# Try https://www.grc.com/passwords.htm
secret_token: SECRET_TOKEN
EOS

File.open("config/settings.local.template.yml", "w") do |f|
  f.puts localSettings.sub("SECRET_TOKEN", "~")
end

File.open("config/settings.local.yml", "w") do |f|
  f.puts localSettings.sub("SECRET_TOKEN", "'" + SecureRandom.hex(128) + "'")
end

safesystem "git add ."
safesystem "git commit -m 'Added rails config gem'"

if options[:bourbon]
  puts "Adding bourbon gem..."

  addGem "bourbon"

  applicationStylesheetsFolder = "app/assets/stylesheets/"
  mkdir applicationStylesheetsFolder + "base"
  mkdir applicationStylesheetsFolder + "components"
  mkdir applicationStylesheetsFolder + "modules"

  touch applicationStylesheetsFolder + "base/body.sass"
  touch applicationStylesheetsFolder + "base/layout.sass"
  touch applicationStylesheetsFolder + "base/typography.sass"

  # Add normalize
  Net::HTTP.start("necolas.github.io") { |http|
    resp = http.get("/normalize.css/2.1.1/normalize.css")
    File.open("vendor/assets/stylesheets/normalize.css", "w") { |file|
      file.write(resp.body)
    }
  }

  applicationCssFile = applicationStylesheetsFolder + "application.css"
  applicationScssFile = applicationCssFile + ".scss"

  mv applicationCssFile, applicationScssFile

  scssContent = File.read(applicationScssFile)

  #TODO: DOES NOT WORK
  scssContent.gsub /^\*= require_tree \.$\n/, ''

  scssContent += <<EOS

@import "bourbon";
@import "normalize";
@import "base/body";
@import "base/layout";
@import "base/typography";
EOS

  File.open(applicationScssFile, 'w') { |f| f.puts scssContent }

  safesystem "git add -A ."
  safesystem "git commit -m 'Add bourbon gem'"
end

#rm "public/index.html" # apparently no longer created by Rails 3.2
