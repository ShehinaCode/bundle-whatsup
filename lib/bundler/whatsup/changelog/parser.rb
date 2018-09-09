module Bundler
  module Whatsup
    module Changelog

      # Parses content of changelog file by versions
      class Parser
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
        end

        # parse changelog content
        # or nil if @content empty
        #
        # @return [NilClass|Hash]
        def run
          nil if @content.empty?

          # remove empty line and split to array by newline symbol
          lines = @content.split("\r\n")
          result = {}
          current_version = nil
          store = proc do |version, content|
            result[version] = result[version].nil? ? content : result[version] + "\r\n" + content
          end

          lines.map do |line|
            next if line.empty?

            parsed_version = line.match(VERSION_REGEXP)

            if !parsed_version.nil? && !parsed_version[:version].nil? && !parsed_version[:version].empty?
              current_version = parsed_version[:version]
            else
              store.call(current_version, line) unless current_version.nil?
            end
          end

          result
        end
      end

    end
  end
end
