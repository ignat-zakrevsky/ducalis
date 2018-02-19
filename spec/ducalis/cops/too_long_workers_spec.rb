# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/too_long_workers'

RSpec.describe Ducalis::TooLongWorkers do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'Max' => 5, 'CountComments' => false } }
  before { allow(cop).to receive(:cop_config).and_return(cop_config) }

  it '[rule] raises for a class with more than 5 lines' do
    inspect_source(['class TestWorker',
                    '  a = 1',
                    '  a = 2',
                    '  a = 3',
                    '  a = 4',
                    '  a = 5',
                    '  a = 6',
                    'end'])
    expect(cop).to raise_violation(/too much work/)
  end

  it 'ignores non-worker classes' do
    inspect_source(['class StrangeClass',
                    '  a = 1',
                    '  a = 2',
                    '  a = 3',
                    '  a = 4',
                    '  a = 5',
                    '  a = 6',
                    'end'])
    expect(cop).to_not raise_violation
  end

  it 'accepts a class with 5 lines' do
    inspect_source(['class TestWorker',
                    '  a = 1',
                    '  a = 2',
                    '  a = 3',
                    '  a = 4',
                    '  a = 5',
                    'end'])
    expect(cop).to_not raise_violation
  end

  it 'accepts a class with less than 5 lines' do
    inspect_source(['class TestWorker',
                    '  a = 1',
                    '  a = 2',
                    '  a = 3',
                    '  a = 4',
                    'end'])
    expect(cop).to_not raise_violation
  end

  it 'accepts empty classes' do
    inspect_source(['class TestWorker',
                    'end'])
    expect(cop).to_not raise_violation
  end

  context 'when CountComments is enabled' do
    before { cop_config['CountComments'] = true }

    it 'also counts commented lines' do
      inspect_source(['class TestWorker',
                      '  a = 1',
                      '  #a = 2',
                      '  a = 3',
                      '  #a = 4',
                      '  a = 5',
                      '  a = 6',
                      'end'])
      expect(cop).to raise_violation(/too much work/)
    end
  end
end
