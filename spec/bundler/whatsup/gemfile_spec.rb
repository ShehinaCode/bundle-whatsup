require 'spec_helper'
require 'bundler/whatsup/gemfile'
require 'bundler/whatsup/version'

describe Bundler::Whatsup::Gemfile do

  let(:gemfile) { Bundler::Whatsup::Gemfile.new }
  let(:version_regexp) { /(\d{1,3}.\d{1,3}(.\d{1,3})?)/ }

  describe '#get_version' do
    it { expect(gemfile.version_of('some_not_existing_gem')).to be_nil }
    it { expect(gemfile.version_of('bundler-whatsup')).to eq(Bundler::Whatsup::VERSION) }
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

