require 'octokit'

# Octokit contents behaves as a Hash, but not completely))
cont = Octokit.contents('stympy/faker', path: '/')
CHANGELOG_NAME_REGEXP = /(?<ch_name>changelog|changes).?(md|txt)?/i

files = cont.detect { |node| node[:type] == 'file' && node[:name].match(CHANGELOG_NAME_REGEXP)}
files.fetch(:name)       #=> nil
files[:name]             #=> 'CHANGELOG.md'
files.to_h.fetch(:name)  #=> 'CHANGELOG.md'
