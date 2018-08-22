require_relative './whatsup/version.rb'
require 'whatsup/gem'
require 'bundler'
module Bundle
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
end
