# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/rubocop_disable'

RSpec.describe Ducalis::RubocopDisable do
  subject(:cop) { described_class.new }

  before do
    stub_const('Ducalis::RubocopDisable::SUGGESTIONS',
               'Metric/ParameterLists' => 'COMMENT_1',
               'Metric/AbcSize' => 'COMMENT_2')
  end

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

  it 'could parse what cop was disabled' do
    inspect_source([
                     '# rubocop:disable Metric/AbcSize, Metric/ParameterLists',
                     'def craZyMethoDName; end'
                   ])
    expect(cop).to raise_violation(/COMMENT_1/)
    expect(cop).to raise_violation(/COMMENT_2/)
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
