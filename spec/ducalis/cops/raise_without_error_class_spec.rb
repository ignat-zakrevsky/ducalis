# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/raise_without_error_class'

RSpec.describe Ducalis::RaiseWithoutErrorClass do
  subject(:cop) { described_class.new }

  it '[rule] raises when `raise` called without exception class' do
    inspect_source('raise "Something went wrong"')
    expect(cop).to raise_violation(/exception class/)
  end

  it '[rule] better to `raise` with exception class' do
    inspect_source('raise StandardError, "Something went wrong"')
    expect(cop).not_to raise_violation
  end

  it 'raises when `raise` called without arguments' do
    inspect_source('raise')
    expect(cop).to raise_violation(/exception class/)
  end

  it 'ignores when `raise` called with exception instance' do
    inspect_source('raise StandardError.new("Something went wrong")')
    expect(cop).not_to raise_violation
  end
end
