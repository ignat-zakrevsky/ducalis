# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/unlocked_gem'

RSpec.describe Ducalis::UnlockedGem do
  subject(:cop) { described_class.new }

  it '[rule] raises for gem without version' do
    inspect_source("gem 'pry'")
    expect(cop).to raise_violation(/lock gem/)
  end

  it '[rule] better to lock gem versions' do
    inspect_source([
                     "gem 'pry', '~> 0.10', '>= 0.10.0'",
                     "gem 'rake', '~> 12.1'",
                     "gem 'thor', '= 0.20.0'",
                     "gem 'rspec', github: 'rspec/rspec'"
                   ])
    expect(cop).not_to raise_violation
  end
end
