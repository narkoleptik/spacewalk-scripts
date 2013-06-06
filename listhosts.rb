#!/usr/bin/env ruby
require "xmlrpc/client"
require 'yaml'

creds = YAML.load_file(ENV['HOME'] + "/.spacewalk.yaml")
@SATELLITE_URL = creds['url']
@SATELLITE_LOGIN = creds['username']
@SATELLITE_PASSWORD = creds['password']

if !(creds['password'])
    print "password: "
    system 'stty -echo'
    @SATELLITE_PASSWORD = $stdin.gets.chomp
    system 'stty echo'
    puts ""
end
if ! creds['username']
    print "username: "
    @SATELLITE_LOGIN = $stdin.gets.chomp
end
if ! creds['url']
    print "url: "
    @SATELLITE_URL = $stdin.gets.chomp
end

@client = XMLRPC::Client.new2(@SATELLITE_URL)

@key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
systems = @client.call('system.listActiveSystems', @key)
for system in systems do
   id = system["id"]
   name = system["name"]
   cktime = system["last_checkin"].to_time
   puts "#{id} - #{name} - #{cktime}"
end
@client.call('auth.logout', @key)


