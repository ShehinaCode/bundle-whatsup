require 'spec_helper'
require 'bundler/whatsup/changelog_parser.rb'

describe Bundler::Whatsup::ChangelogParser do
  describe '#run' do
    let(:parser) { described_class.new(content).run }
    let(:values) { parser.values }

    context 'for faker' do
      let(:content) { File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/faker-CHANGELOG.txt") }
      it { expect(parser).to be_a Hash }
      it { expect(values).to all be_a Array }
    end

    context 'for rack' do
      let(:content) { File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/rack-CHANGELOG.txt") }
      it { expect(parser).to be_a Hash }
      it { expect(values).to all be_a Array }
    end

    context 'for thor' do
      let(:content) { File.read("#{RSPEC_ROOT}/fixtures/changelog_parser/thor-CHANGELOG.txt") }
      it { expect(parser).to be_a Hash }
      it { expect(values).to all be_a Array }
    end
  end
end