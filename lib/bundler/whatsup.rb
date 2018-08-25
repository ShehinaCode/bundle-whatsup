require 'bundler/whatsup/version'
require 'bundler'
require 'bundler/whatsup/gemfile'

module Bundler
  module Whatsup
    class Command
      Plugin::API.command('whatsup', self)

      def exec(command, args)
        puts "You have next gems versions installed:\n"
        Bundler::Whatsup::Gemfile.specs_versions
      end
    end
  end
end
