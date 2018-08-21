require './lib/whatsup/version.rb'
require 'bundler'

module Whatsup
  class Whatsup < Bundler::Plugin::API
    # Register bundle whatsup command
    command "my_command"

    # this method is called when we run 'bundle whatsup'
    def exec(command, args)
      puts "Hello, I'm '#{command}' command"
    end
  end
end
