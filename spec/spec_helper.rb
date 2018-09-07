require "bundler/setup"
require "bundler/whatsup"
require "helpers"
require "vcr"

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.expose_dsl_globally = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include Helpers, :include_fake_gems_info_helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.ignore_hosts '127.0.0.2', 'localhost'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  # c.allow_http_connections_when_no_cassette = true
end
