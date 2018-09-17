require 'bundler/whatsup/version'
require 'bundler'
require 'bundler/whatsup/gemfile_fetcher'

module Bundler
  module Whatsup
    class Command
      Plugin::API.command('whatsup', self)

      def exec(command, args)
        puts "You have next gems versions installed:\n"
        gemfile = Bundler::Whatsup::GemfileFetcher.new
        p gemfile.dependencies_versions
      end
    end
  end
end
