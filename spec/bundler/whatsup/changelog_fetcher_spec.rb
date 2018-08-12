require 'spec_helper'
require 'bundler/whatsup/changelog_fetcher.rb'
require 'vcr'

describe Bundler::Whatsup::ChangelogFetcher, :vcr do

  let(:faker_url)       { 'https://github.com/stympy/faker' }
  let(:octokit_url)     { 'https://github.com/octokit/octokit.rb' }
  let(:faker_git_url)   { 'https://github.com/stympy/faker.git' }
  let(:trailblazer_url) { 'https://github.com/trailblazer/trailblazer' }

  let(:trailblazer_gem_info) { {'source_code_uri' => trailblazer_url, 'homepage_uri' => nil} }
  let(:trailblazer_fetcher) { described_class.new(trailblazer_gem_info) }

  describe '.load' do

    subject { described_class.load(gem_name) }

    let(:gem_name) { 'aaabbbccccdddd' }
    context 'when given gem name is not exists' do
      it 'raises an Argument error' do
        expect { described_class.load(gem_name) }.to raise_error(ArgumentError)
      end
    end

    context 'when gem with given name exists' do
      let(:gem_name) { 'faker' }
      it { is_expected.to be_an_instance_of Bundler::Whatsup::ChangelogFetcher }
      it { is_expected.not_to be_nil }
    end
  end


  describe '#repo_name' do

    subject { described_class.new(gem_info).repo_name }

    context "when 'homepage_uri' is not presented" do
      let(:gem_info) { {'source_code_uri' => faker_url, 'homepage_uri' => nil} }
      it { is_expected.to eq('stympy/faker') }
    end

    context "when 'source_code_uri' is not presented" do
      let(:gem_info) { {'source_code_uri' => nil, 'homepage_uri' => faker_url} }
      it { is_expected.to eq('stympy/faker') }
    end

    context "when both 'homepage_uri' and 'source_code_uri' is not presented" do
      let(:gem_info) { {'source_code_uri' => nil, 'homepage_uri' => nil} }

      it 'raises NameError' do
        expect { described_class.new(gem_info.repo_name) }.to raise_error(NameError)
      end
    end

    context "when uri contains a dots ('octokit/octokit.rb')" do
      let(:gem_info) { {'source_code_uri' => octokit_url, 'homepage_uri' => nil} }
      it { is_expected.to eq('octokit/octokit.rb') }
    end

    context "when uri contains '.git' at the end" do
      let(:gem_info) { {'source_code_uri' => faker_git_url, 'homepage_uri' => nil} }
      it { is_expected.to eq('stympy/faker') }
    end
  end


  describe '#changelog?' do

    subject { described_class.load(gem_name).changelog? }
    context 'when CHANGELOG.md is presented at repo' do
      let(:gem_name) { 'faker' }
      it { is_expected.to be_truthy }
    end

    context 'when CHANGELOG.md is not presented at repo, returned value' do
      let(:gem_name) { 'rails' }
      it { is_expected.to be_falsey }
    end
  end


  describe '#content' do

    subject { described_class.load(gem_name).content }
    context 'when CHANGELOG.md is presented at repo' do
      let(:gem_name) { 'faker' }
      it { is_expected.to be_a String }
      it { is_expected.not_to be_nil }
      it { expect(subject.length).to be > 0 }
    end

    context 'when CHANGELOG.md is not presented at repo' do
      let(:gem_name) { 'rails' }
      it { is_expected.to be_nil }
    end
  end


  describe '#filename' do

    subject { described_class.load(gem_name).filename}
    context 'when changelog file is not found at root of the repo' do
      let(:gem_name) { 'rails' }
      it { is_expected.to be_nil }
    end

    context 'when changelog file is found at root of the repo' do
      let(:gem_name) { 'faker' }
      it { is_expected.to eq('CHANGELOG.md') }
    end

    context 'when changelog filename differs from CHANGELOG.md' do

      describe 'CHANGES.md' do
        subject { trailblazer_fetcher.filename }
        it { is_expected.to eq('CHANGES.md') }
      end

      # TODO: find a gem with *.txt changelog filename
      describe 'CHANGELOG.txt' do
      end

      # TODO: find a gem with *.txt changelog filename
      describe 'CHANGELOG' do
      end
    end
  end
end
