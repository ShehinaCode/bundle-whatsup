require 'bundler'

module Bundler
  module Whatsup
    class Gemfile
      attr_accessor :specs, :dependencies

      def initialize
        @specs = Bundler.load.specs.sort_by(&:name)
        @dependencies = Bundler.load.dependencies.sort_by(&:name)
      end

      # Returns Hash: spec_name=>version
      def specs_versions
        specs_versions = {}
        specs.map do |spec|
          specs_versions[spec.name.to_sym] = spec.version.to_s
        end

        specs_versions
      end

      # Returns Hash: dependency_name=>version
      def dependencies_versions
        dependencies_versions = {}
        dependencies.each do |dependency|
          dependencies_versions[dependency.name.to_sym] = specs_versions[dependency.name.to_sym]
        end

        dependencies_versions
      end
    end
  end
end
