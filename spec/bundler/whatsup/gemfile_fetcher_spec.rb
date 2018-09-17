require 'spec_helper'
require 'bundler/whatsup/gemfile_fetcher'


describe Bundler::Whatsup::SpecsSet do
  let(:version_regexp) {/(\d{1,3}.\d{1,3}(.\d{1,3})?)/}
  subject(:specs) { described_class.new }

  describe '#all' do
    it 'returns a Bundler::SpecSet object' do
      expect(specs.all).to be_a Bundler::SpecSet
    end
  end

  describe '#versions' do
    it 'returns a spec_name=>spec_version Hash' do
      expect(specs.versions).to be_a Hash
    end

    it 'should match to regexp' do
      expect(specs.versions.values).to all(match(version_regexp))
    end
  end
end


describe Bundler::Whatsup::DependenciesSet do
  let(:specs) { Bundler::Whatsup::SpecsSet.new }
  let(:version_regexp) {/(\d{1,3}.\d{1,3}(.\d{1,3})?)/}
  subject(:deps) { described_class.new(specs) }

  describe '#all' do
    it 'returns an Array with dependencies names' do
      expect(deps.all).to be_a Array
    end
  end

  describe '#versions' do
    it 'returns a dependency_name=>dependency_version Hash' do
      expect(deps.versions).to be_a Hash
    end

    it 'should match to regexp' do
      expect(deps.versions.values).to all(match(version_regexp))
    end
  end
end


describe Bundler::Whatsup::GemfileFetcher do
  let(:gemfile) {Bundler::Whatsup::GemfileFetcher.load}

  describe '#specs' do
    subject {gemfile.specs}
    it { is_expected.to be_a Bundler::Whatsup::SpecsSet }
  end

  describe '#dependencies' do
    subject {gemfile.dependencies}
    it { is_expected.to be_a Bundler::Whatsup::DependenciesSet }
  end
end
