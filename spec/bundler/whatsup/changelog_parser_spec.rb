require 'spec_helper'
require 'bundler/whatsup/changelog_parser.rb'

describe Bundler::Whatsup::ChangelogParser do

  let(:faker_changelog) {File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/faker.txt")}
  let(:faker_parser) {described_class.new(faker_changelog).run}

  let(:rack_changelog) {File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/rack.txt")}
  let(:rack_parser) {described_class.new(rack_changelog).run}

  let(:thor_changelog) {File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/thor.txt")}
  let(:thor_parser) {described_class.new(thor_changelog).run}

  describe '#run(faker)' do
    it 'should return a Hash' do
      expect(faker_parser).to be_a Hash
    end

    it 'values should be a string' do
      expect(faker_parser.values).to all be_a String
    end
  end

  describe '#run(rack)' do
    it 'should return a Hash' do
      expect(rack_parser).to be_a Hash
    end

    it 'values should be a string' do
      expect(rack_parser.values).to all be_a String
    end
  end

  describe '#run(thor)' do
    it 'should return a Hash' do
      expect(thor_parser).to be_a Hash
    end

    it 'values should be a string' do
      expect(thor_parser.values).to all be_a String
    end
  end
end