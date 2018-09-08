require 'spec_helper'
require 'bundler/whatsup/changelog/fetcher.rb'
require 'vcr'

describe Bundler::Whatsup::Changelog::Fetcher, :vcr do

  describe "#.load" do

    it "raises ArgumentError with given empty name" do
      expect { described_class.load('') }.to raise_error(ArgumentError)
    end
  end

  describe "#fetch_gem_repo_name" do

    it "fetches gem repo name when 'homepage_uri' is empty" do
      gem_info = double("Gems.info")
      allow(gem_info).to receive("[]").with('source_code_uri').and_return("https://github.com/stympy/faker")
      allow(gem_info).to receive("[]").with('homepage_uri').and_return(nil)

      expect(described_class.new(gem_info).send :gem_repo_name).to eq("stympy/faker")
    end

    it "fetches gem repo name when 'source_code_uri' is empty" do
      gem_info = double("Gems.info")
      allow(gem_info).to receive("[]").with('source_code_uri').and_return(nil)
      allow(gem_info).to receive("[]").with('homepage_uri').and_return("https://github.com/stympy/faker")

      expect(described_class.new(gem_info).send :gem_repo_name).to eq("stympy/faker")
     end

    it "raises an Error when both 'homepage_uri' and 'source_code_uri' is empty" do
      gem_info = double("Gems.info")
      allow(gem_info).to receive("[]").with('source_code_uri').and_return(nil)
      allow(gem_info).to receive("[]").with('homepage_uri').and_return(nil)

      expect { described_class.new(gem_info).send :gem_repo_name }.to raise_error NameError
    end

    it "fetches a right gem repo name when it contains a dots ('octokit/octokit.rb')" do
      gem_info = double("Gems.info")
      allow(gem_info).to receive("[]").with('source_code_uri').and_return('https://github.com/octokit/octokit.rb')
      allow(gem_info).to receive("[]").with('homepage_uri').and_return(nil)

      expect(described_class.new(gem_info).send :gem_repo_name).to eq('octokit/octokit.rb')
    end

    it "fetches a right gem repo name when uri contains '.git' at the end" do
      gem_info = double("Gems.info")
      allow(gem_info).to receive("[]").with('source_code_uri').and_return('https://github.com/stympy/faker.git')
      allow(gem_info).to receive("[]").with('homepage_uri').and_return(nil)

      expect(described_class.new(gem_info).send :gem_repo_name).to eq('stympy/faker')
    end
  end

    let(:rails_gem_info) { double(:rails_gem_info) }
    let(:faker_gem_info) { double(:faker_gem_info) }

    before do

      allow(rails_gem_info).to receive("[]").with("name").and_return("rails")
      allow(rails_gem_info).to receive("[]").with("source_code_uri").and_return("https://github.com/rails/rails")
      allow(rails_gem_info).to receive("[]").with("homepage_uri").and_return(nil)

      allow(faker_gem_info).to receive("[]").with("name").and_return("faker")
      allow(faker_gem_info).to receive("[]").with("source_code_uri").and_return("https://github.com/stympy/faker")
      allow(faker_gem_info).to receive("[]").with("homepage_uri").and_return(nil)
    end

  describe "#load_changelog" do

    context "when CHANGELOG.md is presented at repo returned value" do
      subject { described_class.new(faker_gem_info).send :load_changelog }
      it { is_expected.to be_a String }
      it { is_expected.not_to be_nil }
      it { expect(subject.length).to be > 0 }
    end

    context "when CHANGELOG.md is not presented at repo, returned value" do
      subject { described_class.load('rails').send :load_changelog }
      it { is_expected.to be_nil }
    end
  end

  describe "#has_changelog?" do
    context "when CHANGELOG.md is presented at repo, returned value" do
      subject { described_class.load('faker').changelog? }
      it { is_expected.to be_truthy }
    end

    context "when CHANGELOG.md is not presented at repo, returned value" do
      subject { described_class.load('rails').changelog? }
      it { is_expected.to be_falsey}
    end
  end

  describe "#get_changelog" do

    context "when CHANGELOG.md is presented at repo returned value" do
      subject { described_class.load('faker').changelog }
      it { is_expected.to be_a String }
      it { is_expected.not_to be_nil }
      it { expect(subject.length).to be > 0 }
    end

    context "when CHANGELOG.md is not presented at repo" do
      subject { described_class.load('rails').changelog }
      it { is_expected.to be_nil }
    end
  end
end
