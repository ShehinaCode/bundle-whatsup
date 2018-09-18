require 'spec_helper'
require 'bundler/whatsup/gemfile.rb'

describe Bundler::Whatsup::Gemfile do

  let(:gemfile) { Bundler::Whatsup::Gemfile.new }
  let(:version_regexp) { /(\d{1,3}.\d{1,3}(.\d{1,3})?)/ }

  describe '#get_version' do
    it { expect(gemfile.get_version('some_gem')).to be_nil }
    it { expect(gemfile.get_version('bundler-whatsup')).to be_a String }
  end

  describe '#gems_versions' do
    it 'returns a Hash' do
      expect(gemfile.specs_versions).to be_a Hash
    end

    context 'when versions are valid' do
      it 'should match to regexp' do
        expect(gemfile.specs_versions.values).to all(match(version_regexp))
      end
    end
  end

  describe '#dependencies_versions' do
    it 'returns a Hash' do
      expect(gemfile.specs_versions).to be_a Hash
    end
  end
end

