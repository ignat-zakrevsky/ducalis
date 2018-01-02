# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/uncommented_gem.rb'

RSpec.describe Ducalis::UncommentedGem do
  subject(:cop) { described_class.new }

  it 'raises for gem from github without comment' do
    inspect_source(cop, [
                     "gem 'pry', '~> 0.10', '>= 0.10.0'",
                     "gem 'rake', '~> 12.1'",
                     "gem 'rspec', git: 'https://github.com/rspec/rspec'"
                   ])
    expect(cop).to raise_violation(/add comment/)
  end

  it 'ignores for gem from github with comment' do
    inspect_source(cop,
                   [
                     "gem 'pry', '~> 0.10', '>= 0.10.0'",
                     "gem 'rake', '~> 12.1'",
                     "gem 'rspec', github: 'rspec/rspec' # new non released API"
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores gems with require directive' do
    inspect_source(cop,
                   [
                     "gem 'pry', '~> 0.10', '>= 0.10.0'",
                     "gem 'rake', '~> 12.1'",
                     "gem 'rest-client', require: 'rest_client'"
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores gems with group directive' do
    inspect_source(cop,
                   [
                     "gem 'rake', '~> 12.1'",
                     "gem 'wirble', group: :development"
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores gems with group directive and old syntax style' do
    inspect_source(cop,
                   [
                     "gem 'rake', '~> 12.1'",
                     "gem 'wirble', :group => :development"
                   ])
    expect(cop).to_not raise_violation
  end
end
