source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'gems'
gem 'octokit'

group :development do
  plugin 'bundler-whatsup', github: 'ShehinaCode/bundler-whatsup'
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

gemspec
