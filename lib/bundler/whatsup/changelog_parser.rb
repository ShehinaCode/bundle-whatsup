module Bundler
  module Whatsup

    # Parses content of changelog file by versions
    class ChangelogParser
      attr_reader :parsed

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
        @parsed = Hash.new {|h, k| h[k] = []}
      end

      # parse changelog content
      # return nil if @content empty
      #
      # @return [NilClass|Hash]
      def run
        return if @content.empty?

        # remove empty line and split to array by newline symbol
        lines = @content.split("\n").reject(&:empty?)
        current_version = nil

        lines.map do |line|

          # check if line matches regexp and if line has valid version
          if (m = line.match(VERSION_REGEXP))
            current_version = m[:version]
            next
          end

          parsed[current_version] << line unless current_version.nil?
        end

        parsed
      end
    end
  end
end
