# frozen_string_literal: true

require 'bundler/setup'
require 'rubocop/rspec/support'
require 'rspec/expectations'

require 'ducalis'

Dir['spec/support/**/*.rb'].each { |f| require f.sub('spec/', '') }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec::Matchers.define :raise_violation do |like, count: 1|
  match do |cop|
    cop.offenses.size == count && cop.offenses.first.message.match(like)
  end

  match_when_negated do |cop|
    cop.offenses.empty?
  end
end

CopHelper.prepend(CopHelperCast)
