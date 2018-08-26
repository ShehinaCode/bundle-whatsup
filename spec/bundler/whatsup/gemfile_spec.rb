require 'spec_helper'
require 'bundler/whatsup/gemfile.rb'

describe Bundler::Whatsup::Gemfile do

  let(:gemfile) { Bundler::Whatsup::Gemfile.new }
  let(:version_regexp) { /(\d{1,3}.\d{1,3}(.\d{1,3})?)/ }

  describe "#gems_versions" do
    it "returns a Hash" do
      expect(gemfile.specs_versions).to be_a Hash
    end

    it 'when versions are valid' do
      expect(gemfile.specs_versions.values).to all(match(version_regexp))
    end
  end

  describe "#dependencies_versions" do
    it "returns a Hash" do
      expect(gemfile.specs_versions).to be_a Hash
    end
  end
end
