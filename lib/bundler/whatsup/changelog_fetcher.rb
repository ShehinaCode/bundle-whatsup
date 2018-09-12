require 'fileutils'
require 'open-uri'
require 'gems'
require 'octokit'

module Bundler
  module Whatsup
    # Fetches changelog file for given gem name
    #
    # @example
    #   changelog_content = ChangelogFetcher.load('sinatra').content
    #   has_changelog     = ChangelogFetcher.load('rais').changelog?
    class ChangelogFetcher

      attr_reader :content

      CHANGELOG_NAME_REGEXP = /(?<ch_name>changelog|changes).?(md|txt)?/i
      GITHUB_REPO_REGEXP = %r{(https|http)://github.com/(?<gem_repo_name>[\S]+/[\S]+)}

      def initialize(gem_info)
        @url = gem_info.values_at('source_code_uri', 'homepage_uri').compact.grep(GITHUB_REPO_REGEXP).first or
          raise ArgumentError, "No valid source or homepage url specified for gem #{gem_info['name']}"
        load_changelog
      end

      class << self

        # Creates and setups Changelog::Fetcher object for given gem name
        #
        # @param gem_name [String] Name of the gem
        # @return [ChangelogFetcher]
        # @example
        #   Changelog::Fetcher.load('nokogiri')
        def load(gem_name)
          gem_info = Gems.info(gem_name.downcase)
          raise ArgumentError, "Gem #{gem_name} not found" if gem_info.empty?
          new(gem_info)
        end

      end

      # Checks if gem has changelog file or not
      #
      # @return [Boolean]
      def changelog?
        !@content.nil?
      end

      # Resolves changelog filename
      #
      # @return [String|nil]
      def filename
        @changelog_file_name ||= resolve_filename
      end

      # Calculates gem repository name and its owner name at Github based on urls presented in gem metadata
      #
      # @return [String]
      def repo_name
        @repo_name ||= Octokit::Repository.from_url(@url).to_s.chomp('.git')
      end

      private

      # Loads changelog file and sets its content to @changelog if one is presented
      #
      # @return [ChangelogFetcher]
      def load_changelog
        return self unless filename
        @content = Base64.decode64(Octokit.contents(repo_name, path: filename).content)
        self
      end

      def resolve_filename
        Octokit.contents(repo_name, path: '/')
          .map(&:to_h)
          .detect { |node| node[:type] == 'file' && node[:name].match(CHANGELOG_NAME_REGEXP)}
          &.fetch(:name)
      end
    end
  end
end
