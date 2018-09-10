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
  changelog_name = file_name if filename && file_name.downcase!.match(changelog_name_regexp)
end
changelog_name
