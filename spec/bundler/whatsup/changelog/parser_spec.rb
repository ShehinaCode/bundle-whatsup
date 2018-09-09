require 'spec_helper'
require 'bundler/whatsup/changelog/parser.rb'

describe Bundler::Whatsup::Changelog::Parser do

  let(:faker_changelog) { File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/faker.txt") }
  let(:faker_parser) { described_class.new(faker_changelog).run }

  describe '#run' do
    it 'should return a Hash' do
      expect(faker_parser).to be_a Hash
    end

    it 'values should be a string' do
      expect(faker_parser.values).to all be_a String
    end
  end

end