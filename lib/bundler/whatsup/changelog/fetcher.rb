require 'fileutils'
require 'open-uri'
require 'gems'
require 'octokit'

module Bundler
  module Whatsup
    module Changelog

      class Fetcher

        class << self

          def load(gem_name)
            gem_info = Gems.info(gem_name.downcase)
            raise ArgumentError, "Gem #{gem_name} not found" if gem_info.empty?

            fetcher = new(gem_info)
            fetcher.send :load_changelog
            fetcher
          end

        end

        def initialize(gem_info)
          @source_code_uri = gem_info['source_code_uri']
          @homepage_uri    = gem_info['homepage_uri']
        end

        def get_changelog
          @changelog
        end

        def has_changelog?
          !!@changelog
        end

        private

        def fetch_gem_repo_name
          gem_repo_name_regexp = /(https|http):\/\/github.com\/(?<gem_repo_name>[\S]+\/[\S]+)/
          gem_repo_name = nil

          if @source_code_uri && @source_code_uri.match(gem_repo_name_regexp)
            gem_repo_name = @source_code_uri.match(gem_repo_name_regexp)[:gem_repo_name]
          elsif @homepage_uri && @homepage_uri.match(gem_repo_name_regexp)
            gem_repo_name = @homepage_uri.match(gem_repo_name_regexp)[:gem_repo_name]
          else
            raise NameError, "No valid source or homepage url specified for gem #{@gem_name}"
          end

          @gem_repo_name = gem_repo_name.chomp '.git'
          @gem_repo_name
        end

        def load_changelog
          path = 'CHANGELOG.md'

          begin
            changelog_download_url = Octokit.contents(fetch_gem_repo_name, path: path)[:download_url]
            @changelog = open(changelog_download_url).read
          rescue Octokit::NotFound
            @changelog = nil
          end

        end
      end
    end
  end
end
