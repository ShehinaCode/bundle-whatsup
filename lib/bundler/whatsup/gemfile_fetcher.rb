require 'bundler'

module Bundler
  module Whatsup
    # Works with dependencies and specs described in Gemfile
    class GemfileFetcher
      attr_reader :specs, :dependencies

      def initialize(specs, dependencies)
        @specs = specs
        @dependencies = dependencies
      end

      class << self

        def load
          specs_set = SpecsSet.new
          dependencies_set = DependenciesSet.new(specs_set)
          new(specs_set, dependencies_set)
        end

      end

    end

    # Retrieves all specs for Gemfile
    class SpecsSet

      def initialize
        @specs = Bundler.load.specs
      end

      def all
        @specs
      end

      # Retrieves Gemfile specs
      # Returns Hash: spec_name=>version
      #
      # @return [Hash]
      def versions
        specs_versions = {}
        @specs.map do |spec|
          specs_versions[spec.name.to_sym] = spec.version.to_s
        end

        specs_versions
      end
    end

    # Gemfile dependencies and their versions from all specs
    class DependenciesSet

      # @param specs_versions [SpecsSet]
      def initialize(specs_versions)
        @dependencies = Bundler.load.dependencies
        @specs_versions = specs_versions.versions
      end

      def all
        @dependencies
      end

      # Retrieves Gemfile dependencies
      # Returns Hash: dependency_name=>version
      #
      # @return [Hash]
      def versions
        dependencies_versions = {}
        @dependencies.each do |dependency|
          dependencies_versions[dependency.name.to_sym] = @specs_versions[dependency.name.to_sym]
        end

        dependencies_versions
      end
    end
  end
end


