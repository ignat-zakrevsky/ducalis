# frozen_string_literal: true

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

  it 'ignores if method definition contains default values through keywords' do
    inspect_source('def calculate(step, index, dry: true); end')
    expect(cop).to_not raise_violation
  end

  it 'ignores for methods without arguments' do
    inspect_source('def calculate_amount; end')
    expect(cop).to_not raise_violation
  end

  it 'ignores for class methods without arguments' do
    inspect_source('def self.calculate_amount; end')
    expect(cop).to_not raise_violation
  end
end
