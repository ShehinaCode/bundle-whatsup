module Helpers
  class FakeGemsInfo
    attr_accessor :name, :downloads, :version, :version_downloads, :platform, :authors, :info, :licenses, :metadata, :sha, :project_uri,
      :gem_uri, :homepage_uri, :wiki_uri, :documentation_uri, :mailing_list_uril, :source_code_uri, :bug_tracker_uri, :changelog_uri, :dependencies

    def initialize
      @name              = 'faker'
      @downloads         = 1111111111
      @version           = '1.9.1'
      @version_downloads = 11111
      @platform          = 'ruby'
      @authors           = 'Fake Gems Info'
      @info              = 'Fake class that emulates Gem.info Hash'
      @licenses          = ['FAKE']
      @metadata          = {}
      @sha               = 'facefacefacefaceface'
      @project_uri       = 'https://rubygems.org/gems/fake_gems_info'
      @gem_uri           = 'https://rubygems.org/gems/fake_gems_info-1.1.1.gem'
      @source_code_uri   = 'https://github.com/stympy/faker'
      @homepage_uri      = 'https://github.com/stympy/faker'
      @wiki_uri          = nil
      @documentation_uri = 'http://www.rubydoc.info/gems/faker/1.9.1'
      @mailing_list_uril = nil
      @bug_tracker_uri   = nil
      @changelog_uri     = 'https://raw.githubusercontent.com/stympy/faker/master/CHANGELOG.md'
      @dependencies      = {}
    end

    def [](key)
      send key.to_s
    end
  end


  class EmptyHomepageUriFGI < FakeGemsInfo

    def homepage_uri
      nil
    end
  end

  class EmptySourceCodeFGI < FakeGemsInfo

    def source_code_uri
      nil
    end
  end

  class EmptySourceAndHomepageUriFGI < FakeGemsInfo

    def source_code_uri
      nil
    end

    def homepage_uri
      nil
    end
  end

  class OctokitDotRbRepoNameWithDotFGI < FakeGemsInfo

    def source_code_uri
      'https://github.com/octokit/octokit.rb'
    end

    def homepage_uri
      nil
    end
  end

  class RepoUriWithDotGitFGI < FakeGemsInfo

    def source_code_uri
      'https://github.com/stympy/faker.git'
    end

    def homepage_uri
      nil
    end
  end
end

