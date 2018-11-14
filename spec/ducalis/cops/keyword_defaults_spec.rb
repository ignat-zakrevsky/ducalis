# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/keyword_defaults'

RSpec.describe Ducalis::KeywordDefaults do
  subject(:cop) { described_class.new }

  it '[rule] raises if method definition contains default values' do
    inspect_source('def calculate(step, index, dry = true); end')
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'raises if class method definition contains default values' do
    inspect_source('def self.calculate(step, index, dry = true); end')
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it '[rule] better to pass default values through keywords' do
    inspect_source('def calculate(step, index, dry: true); end')
    expect(cop).not_to raise_violation
  end

  it 'ignores for methods without arguments' do
    inspect_source('def calculate_amount; end')
    expect(cop).not_to raise_violation
  end

  it 'ignores for class methods without arguments' do
    inspect_source('def self.calculate_amount; end')
    expect(cop).not_to raise_violation
  end

  it 'does not raise when method contains only 1 argument' do
    inspect_source('def calculate(dry = true); end')
    expect(cop).not_to raise_violation
  end
end
