require 'bundler'
require 'open-uri'
require 'json'
require 'fileutils'

module Bundler
  module Whatsup
    class GemInfo
      attr_accessor :dependencies, :sources, :links
      attr_reader :api_url

      def initialize
        @dependencies = Bundler.load.dependencies.sort_by(&:name)
        @api_url = 'https://rubygems.org/api/v1/gems/'
        @sources = {}
        @links = {}
      end

      def gems_sources
        dependencies.map do |dependency|
          response = open_api(api_url + dependency.name.to_s + '.json')
          next if response.nil?
          source = response["source_code_uri"]
          sources[dependency.name] = source if source.match(/(https|http):\/\/github.com\/[\w]+\/[\S]+/)
        end

        self
      end

      def gems_changelogs
        nil if sources.empty?
        
        sources.each do |key, source|

          match_group = source.match(/(https|http):\/\/github.com\/(?<repo_path>[\w]+\/[\w]+)/)
          repo_path = match_group[:repo_path]

          response = open_api('https://api.github.com/repos/' + repo_path + '/contents/CHANGELOG.md')

          next if response.nil?

          download_link = response["download_url"]
          
          path = "./tmp/"

          FileUtils.mkdir_p(path) unless File.exist?(path)

          File.open(File.join(path, "#{key}-CHANGELOG.md"), 'wb') do |f|
            f.write open_api(download_link, false)
          end
        end
        
        self
      end

      private

        def open_api(uri, json = true)
          begin
            response = JSON.parse(open(uri).read) if json
            response = open(uri).read unless json
          rescue
            nil
          else
            response
          end
        end
    end
  end
end

