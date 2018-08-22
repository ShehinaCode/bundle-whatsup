require 'bundler/whatsup/version'
require 'bundler'

module Bundler
  module Whatsup
    class Command
      Plugin::API.command('whatsup', self)

      def exec(command, args)
        puts "Hello, I'm #{command} command"
      end
    end
  end
end
