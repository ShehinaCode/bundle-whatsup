require 'octokit'
require 'json'

contents_response = Octokit.contents('octokit/octokit.rb', path: '/')
changelog_name_regexp = /(?<ch_name>changelog|changes).?(md|txt)?/
files = []
contents_response.each do |node|
  files.push(node[:name]) if node[:type] == 'file'
end
changelog_name = nil
files.each do |file_name|
  p file_name
  if file_name.downcase.match(changelog_name_regexp)
    changelog_name = file_name
  end
end
changelog_name
