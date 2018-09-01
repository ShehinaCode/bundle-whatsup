require 'spec_helper'
require 'bundler/whatsup/gem_info.rb'

describe Bundler::Whatsup::GemInfo do

  before(:all) { @gem_info = described_class.new }

  describe "#gems_sources" do
    before(:all) { @gem_info.gems_sources }
    let(:uri_github_pattern) { /(https|http):\/\/github.com\/[\w]+\/[\S]+/ }

    it "returns a Hash" do
      expect(@gem_info.sources).to be_a Hash
    end

    it "values must match a URL" do
      expect(@gem_info.sources.values).to all( match(uri_github_pattern) )
    end

  end

  describe "#gems_changelogs", :type => :aruba do
    let(:file) { 'Gemfile' }

    # TODO: test ↓ may be passed
    it "creates a bundler changelog file" do
      @gem_info.gems_sources.gems_changelogs

      # Uncomment line ↓
      # expect(File.join(File.dirname(__FILE__), file)).to be_an_existing_file
    end

  end

end
