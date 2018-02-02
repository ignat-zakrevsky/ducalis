# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/rubocop_disable'

RSpec.describe Ducalis::RubocopDisable do
  subject(:cop) { described_class.new }

  it '[rule] raises on RuboCop disable comments' do
    inspect_source(cop, [
                     '# rubocop:disable Metrics/ParameterLists',
                     'def calculate(five, args, at, one, list); end'
                   ])
    expect(cop).to raise_violation(/RuboCop/)
  end

  it 'ignores comment without RuboCop disabling' do
    inspect_source(cop, [
                     '# some meaningful comment',
                     'def calculate(five, args, at, one, list); end'
                   ])
    expect(cop).to_not raise_violation
  end
end
