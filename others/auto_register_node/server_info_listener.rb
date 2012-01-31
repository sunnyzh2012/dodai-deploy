#!/usr/bin/env ruby

require 'socket'

port = 12345

require File.dirname(__FILE__) + '/utils'

def update_settings(name)
  puts "update settings."
  `sed -i -e "s/SERVER/#{name}/" /etc/mcollective/server.cfg`
end

def restart_services()
  puts "restart mcollective."
  `/etc/init.d/mcollective stop`
  `/etc/init.d/mcollective start`
end

udps = UDPSocket.open()
udps.bind("0.0.0.0", port)

loop do
  name, ip = udps.recv(65535).split(":")
  puts name
  puts ip

  old_ip = get_ip name
  puts "old_ip: " + old_ip

  if old_ip == ""
    add_host name, ip
  else
    update_host name, ip
  end

  if system("grep SERVER /etc/mcollective/server.cfg")
    update_settings name
    restart_services
  end
end

udps.close