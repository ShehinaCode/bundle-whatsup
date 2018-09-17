require 'bundler/whatsup/version'
require 'bundler'
require 'bundler/whatsup/gemfile_fetcher'

module Bundler
  module Whatsup
    class Command
      Plugin::API.command('whatsup', self)

      def exec(command, args)
        puts "You have next gems versions installed:\n"
        gemfile_fetcher = Bundler::Whatsup::GemfileFetcher.load
        p gemfile_fetcher.specs.versions
      end
    end
  end
end
