require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require 'braino'
require 'rack/test'
require 'webmock/rspec'

Airborne.configure do |config|
  config.rack_app = API
  # config.base_url = 'http://example.com/api/v1'
  config.headers = { 'accept' => 'application/json', 'content-type' => 'application/json' }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end
