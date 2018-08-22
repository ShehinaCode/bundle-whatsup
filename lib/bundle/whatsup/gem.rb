
module Bundle
  module Whatsup
    class Gem
      def self.all_with_versions
        require 'bundler'
        
        specs = Bundler.load.specs.sort_by(&:name)
    
        gems = {}

        specs.map do |gem|
            gems[gem.name.to_sym] = {version: gem.version.to_s}
        end

        gems
      end
    end
  end
end