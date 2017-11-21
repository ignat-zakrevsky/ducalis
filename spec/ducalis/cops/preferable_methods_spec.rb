# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/preferable_methods.rb'

RSpec.describe Ducalis::PreferableMethods do
  subject(:cop) { described_class.new }

  it 'raises for `delete` method calling' do
    inspect_source(cop, 'User.where(id: 7).delete')
    expect(cop).to raise_violation(/destroy/)
  end

  it 'ignores calling `delete` with symbol' do
    inspect_source(cop, 'params.delete(:code)')
    expect(cop).to_not raise_violation
  end

  it 'ignores calling `delete` with string' do
    inspect_source(cop, 'string.delete("-")')
    expect(cop).to_not raise_violation
  end

  it 'ignores calling `delete` with multiple args' do
    inspect_source(cop, 'some.delete(1, header: [])')
    expect(cop).to_not raise_violation
  end

  it 'ignores calling `delete` on files-like variables' do
    inspect_source(cop, 'tempfile.delete')
    expect(cop).to_not raise_violation
  end
end
