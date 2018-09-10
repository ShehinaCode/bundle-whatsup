require 'fileutils'
require 'open-uri'
require 'gems'
require 'octokit'

module Bundler
  module Whatsup
    module Changelog
      # Fetches changelog file for given gem name
      class Fetcher

        attr_reader :changelog

        def initialize(gem_info)
          @source_code_uri = gem_info['source_code_uri']
          @homepage_uri = gem_info['homepage_uri']
          load_changelog
        end

        class << self

          # Creates and setups Changelog::Fetcher object for given gem name
          #
          # @param gem_name [String] Name of the gem
          # @return [Changelog::Fetcher]
          # @example
          #   Changelog::Fetcher.load('nokogiri')
          def load(gem_name)
            gem_info = Gems.info(gem_name.downcase)
            raise ArgumentError, "Gem #{gem_name} not found" if gem_info.empty?
            fetcher = new(gem_info)
          end

        end

        # Checks if gem has changelog file or not
        #
        # @return [Boolean]
        def changelog?
          !@changelog.nil?
        end

        # Resolves changelog filename
        #
        # @return [String|nil]
        def changelog_file_name
          return @changelog_file_name unless @changelog.nil?
          contents_response = Octokit.contents(gem_repo_name, path: '/')
          changelog_name_regexp = /(?<ch_name>changelog|changes).?(md|txt)?/
          files = []
          contents_response.each do |node|
            files.push(node[:name]) if node[:type] == 'file'
          end
          @changelog_file_name = nil
          unless files.empty?
            files.each do |file_name|
              @changelog_file_name = file_name if file_name.downcase!.match(changelog_name_regexp)
            end
          end
          @changelog_file_name
        end

        private

        # Calculates gem repository name and its owner name at Github based
        # on urls presented in gem metadata
        #
        # @return [String]
        def gem_repo_name
          gem_repo_name_regexp = %r{(https|http)://github.com/(?<gem_repo_name>[\S]+/[\S]+)}

          if @source_code_uri && @source_code_uri.match(gem_repo_name_regexp)
            gem_repo_name = @source_code_uri.match(gem_repo_name_regexp)[:gem_repo_name]
          elsif @homepage_uri && @homepage_uri.match(gem_repo_name_regexp)
            gem_repo_name = @homepage_uri.match(gem_repo_name_regexp)[:gem_repo_name]
          else
            raise NameError, "No valid source or homepage url specified for gem #{@gem_name}"
          end

          @gem_repo_name = gem_repo_name.chomp '.git'
        end

        # Loads changelog file and sets it content to @changelog
        # if one is presented
        #
        # @return [String|Boolean]
        def load_changelog
          changelog_download_url = Octokit.contents(gem_repo_name, path: changelog_file_name)[:download_url]
          @changelog = open(changelog_download_url).read
        rescue Octokit::NotFound
          @changelog = nil
        end
      end
    end
  end
end
