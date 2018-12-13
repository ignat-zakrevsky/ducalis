# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/complex_statements'

RSpec.describe Ducalis::ComplexStatements do
  subject(:cop) { described_class.new }

  it '[rule] raises on complex or statements' do
    inspect_source([
                     'if divisible(4) && (divisible(400) || !divisible(100))',
                     '  puts "This is a leap year!"',
                     'end'
                   ])
    expect(cop).to raise_violation(/complex/)
  end

  it 'raises for complex unless statements (especially!)' do
    inspect_source('puts "Hi" unless a_cond && b_cond || c_cond')
    expect(cop).to raise_violation(/complex/)
  end

  it '[rule] better to move a complex statements to method' do
    inspect_source([
                     'if leap_year?',
                     '  puts "This is a leap year!"',
                     'end',
                     '',
                     'private',
                     '',
                     'def leap_year?',
                     '  divisible(4) && (divisible(400) || !divisible(100))',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
