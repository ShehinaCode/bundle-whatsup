require './lib/whatsup/version.rb'
require 'bundler'

module Whatsup

  # Register bundle whatsup command
  Bundler::Plugin::API.command('whatsup', self)

  # this method is called when we run 'bundle whatsup'
  def exec(command, args)
    puts "Hello, I'm '#{command}' command"
  end
end
