require 'bundler'
require 'open-uri'
require 'json'

module Bundler
  module Whatsup
    class GemInfo
      attr_accessor :dependencies, :sources
      attr_reader :api_url

      def initialize
        @dependencies = Bundler.load.dependencies.sort_by(&:name)
        @api_url = 'https://rubygems.org/api/v1/gems/'
        @sources = {}
      end

      def gems_sources
        dependencies.map do |dependency|
          begin
            request = open(api_url + dependency.name.to_s + '.json')
          rescue
            next
          else
            response = JSON.parse(request.read)
            source = response["source_code_uri"]
            sources[dependency.name] = source if source.match(/(https|http):\/\/github.com\/[\w]+\/[\S]+/)
          end
        end
      end
    end
  end
end

