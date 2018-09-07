require 'spec_helper'
require 'bundler/whatsup/changelog/fetcher.rb'
require 'vcr'

describe Bundler::Whatsup::Changelog::Fetcher, :vcr do

  describe "#.load" do

    it "raises ArgumentError with given empty name" do
      expect { described_class.load('') }.to raise_error(ArgumentError)
    end
  end

  describe "#fetch_gem_repo_name", :include_fake_gems_info_helpers do

    subject(:empty_homepage_uri)                { described_class.new(Helpers::EmptyHomepageUriFGI.new) }
    subject(:empty_source_code_uri)             { described_class.new(Helpers::EmptySourceCodeFGI.new) }
    subject(:empty_source_and_homepage_uri)     { described_class.new(Helpers::EmptySourceAndHomepageUriFGI.new) }
    subject(:octokit_dot_rb_repo_name_with_dot) { described_class.new(Helpers::OctokitDotRbRepoNameWithDotFGI.new) }
    subject(:repo_url_with_dot_git)             { described_class.new(Helpers::RepoUriWithDotGitFGI.new) }

    it "fetches gem repo name when 'homepage_uri' is empty" do
      expect(empty_homepage_uri.send :fetch_gem_repo_name).to eq('stympy/faker')
    end

    it "fetches gem repo name when 'source_code_uri' is empty" do
      expect(empty_source_code_uri.send :fetch_gem_repo_name).to eq('stympy/faker')
    end

    it "raises an Error when both 'homepage_uri' and 'source_code_uri' is empty" do
      expect { empty_source_and_homepage_uri.send :fetch_gem_repo_name }.to raise_error NameError
    end

    it "fetches a right gem repo name when it contains a dots ('octokit/octokit.rb')" do
      expect(octokit_dot_rb_repo_name_with_dot.send :fetch_gem_repo_name).to eq('octokit/octokit.rb')
    end

    it "fetches a right gem repo name when uri contains '.git' at the end" do
      expect(repo_url_with_dot_git.send :fetch_gem_repo_name).to eq('stympy/faker')
    end
  end

  describe "#load_changelog" do

    context "when CHANGELOG.md is presented at repo returned value" do
      subject { described_class.new(Helpers::FakeGemsInfo.new).send :load_changelog }
      it { is_expected.to be_a String }
      it { is_expected.not_to be_nil }
      it { expect(subject.length).to be > 0 }
    end

    context "when CHANGELOG.md is not presented at repo" do
      subject { described_class.load('rails').send :load_changelog }
      it { is_expected.to be_nil }
    end
  end

  describe "#has_changelog?" do
    context "when CHANGELOG.md is presented at repo returned value" do
      subject { described_class.load('faker').has_changelog? }
      it { is_expected.to be_truthy }
    end

    context "when CHANGELOG.md is not presented at repo" do
      subject { described_class.load('rails').has_changelog? }
      it { is_expected.to be_falsey}
    end
  end

  describe "#get_changelog" do

    context "when CHANGELOG.md is presented at repo returned value" do
      subject { described_class.load('faker').get_changelog }
      it { is_expected.to be_a String }
      it { is_expected.not_to be_nil }
      it { expect(subject.length).to be > 0 }
    end

    context "when CHANGELOG.md is not presented at repo" do
      subject { described_class.load('rails').get_changelog }
      it { is_expected.to be_nil }
    end
  end
end
