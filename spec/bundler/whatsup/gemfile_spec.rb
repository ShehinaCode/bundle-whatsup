require 'spec_helper'
require 'bundler/whatsup/gemfile.rb'

describe Bundler::Whatsup::Gemfile do

  let(:gemfile) { Bundler::Whatsup::Gemfile.new }

  describe "#gems_versions" do

    it "returns a Hash" do
      expect(gemfile.specs_versions).to be_a Hash
    end
  end

  describe "#dependencies_versions" do

    it "returns a Hash" do
      expect(gemfile.specs_versions).to be_a Hash
    end
  end
end
