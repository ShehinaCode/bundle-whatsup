require 'bundler/whatsup/version'
require 'bundler'
require 'bundler/whatsup/gemfile_parser'

module Bundler
  module Whatsup
    class Command
      Plugin::API.command('whatsup', self)

      def exec(command, args)
        puts "You have next gems versions installed:\n"
        Bundler::Whatsup::GemfileParser.get_gems_versions
      end
    end
  end
end
