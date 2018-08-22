require 'bundler'

module Bundler
  module Whatsup
    class GemfileParser

      # Returns Hash with gems name and version
      def self.get_gems_versions
        specs = Bundler.load.specs.sort_by(&:name)
        gems = {}
        specs.map do |gem|
            gems[gem.name.to_sym] = gem.version.to_s
        end

        p gems
      end
    end
  end
end
