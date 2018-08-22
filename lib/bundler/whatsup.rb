require 'bundler/whatsup/version'
require 'bundler'
require 'gem_parser'

module Bundler
  module Whatsup
    class Command
      Plugin::API.command('whatsup', self)

      def exec(command, args)
        puts "Hello, I'm #{command} command"
        Gem.get_gems_versions
      end
    end
  end
end
