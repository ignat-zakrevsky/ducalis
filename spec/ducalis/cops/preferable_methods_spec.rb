# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/preferable_methods.rb'

RSpec.describe Ducalis::PreferableMethods do
  subject(:cop) { described_class.new }

  it 'raises for `delete` method calling' do
    inspect_source(cop, 'User.where(id: 7).delete')
    expect(cop).to raise_violation(/destroy/)
  end

  it 'raises `save` method calling with validate: false' do
    inspect_source(cop, 'User.where(id: 7).save(validate: false)')
    expect(cop).to raise_violation(/save/)
  end

  it 'raises `toggle!` method calling' do
    inspect_source(cop, 'User.where(id: 7).toggle!')
    expect(cop).to raise_violation(/toggle.save/)
  end

  it 'ignores `save` method calling without validate: false' do
    inspect_source(cop, 'User.where(id: 7).save')
    inspect_source(cop, 'User.where(id: 7).save(some_arg: true)')
    expect(cop).to_not raise_violation
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
