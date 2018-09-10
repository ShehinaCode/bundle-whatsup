module Bundler
  module Whatsup
    module Changelog

      # Parses content of changelog file by versions
      class Parser
        attr_accessor :parsed
        
        VERSION_REGEXP = /
          ((.+)?[#]+(.+)?)                          # requires that line to be a title
          (?<version>(\d{1,3}\.\d{1,3}\.\d{1,3})    # requires three digits splitted by dots
          (\.pre((.|-)?\d{1,3})?|                   # version can contains a modificators, like: pre, rc, alpha, beta
          .rc((.|-)?\d{1,3})?|
          .alpha((.|-)?\d{1,3})?|
          .beta((.|-)?\d{1,3})?)?)
        /x

        # Initializer
        #
        # @param content [String]
        def initialize(content)
          @content = content
          @parsed = {}
        end

        # parse changelog content
        # or nil if @content empty
        #
        # @return [NilClass|Hash]
        def run
          nil if @content.empty?

          # remove empty line and split to array by newline symbol
          lines = @content.split("\r\n")
          current_version = nil

          lines.map do |line|
            next if line.empty?

            parsed_version = line.match(VERSION_REGEXP)

            # check if line matches regexp and if line has valid version
            unless parsed_version.nil? && parsed_version[:version].nil? && parsed_version[:version].empty?
              current_version = parsed_version[:version]
              next
            end

            store(current_version, line) unless current_version.nil?
          end

          parsed
        end

        private

        def store(version, content)
          parsed[version] = parsed[version].nil? ? content : result[version] + "\r\n" + content
        end
      end
    end
  end
end
