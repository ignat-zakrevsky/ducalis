# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/rubocop_disable'

RSpec.describe Ducalis::RubocopDisable do
  subject(:cop) { described_class.new }

  it '[rule] raises on RuboCop disable comments' do
    inspect_source([
                     '# rubocop:disable Metrics/ParameterLists',
                     'def calculate(five, args, at, one, list); end'
                   ])
    expect(cop).to raise_violation(/RuboCop/)
  end

  it '[rule] better to follow RuboCop comments' do
    inspect_source('def calculate(five, context); end')
    expect(cop).not_to raise_violation
  end

  it 'ignores comment without RuboCop disabling' do
    inspect_source([
                     '# some meaningful comment',
                     'def calculate(five, args, at, one, list); end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'works for empty file' do
    inspect_source('')
    expect(cop).not_to raise_violation
  end
end
