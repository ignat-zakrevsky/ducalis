# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/preferable_methods.rb'

RSpec.describe Ducalis::PreferableMethods do
  subject(:cop) { described_class.new }

  it '[rule] raises for `delete` method calling' do
    inspect_source('User.where(id: 7).delete')
    expect(cop).to raise_violation(/destroy/)
  end

  it '[rule] better to use callback-calling methods' do
    inspect_source('User.where(id: 7).destroy')
    expect(cop).not_to raise_violation
  end

  it '[rule] raises `update_column` method calling' do
    inspect_source('User.where(id: 7).update_column(admin: false)')
    expect(cop).to raise_violation(/update/)
    expect(cop).to raise_violation(/update_attributes/)
  end

  it 'raises `save` method calling with validate: false' do
    inspect_source('User.where(id: 7).save(validate: false)')
    expect(cop).to raise_violation(/save/)
  end

  it 'raises `toggle!` method calling' do
    inspect_source('User.where(id: 7).toggle!')
    expect(cop).to raise_violation(/toggle.save/)
  end

  it 'ignores `save` method calling without validate: false' do
    inspect_source('User.where(id: 7).save')
    inspect_source('User.where(id: 7).save(some_arg: true)')
    expect(cop).not_to raise_violation
  end

  it 'ignores calling `delete` on params' do
    inspect_source('params.delete(code)')
    expect(cop).not_to raise_violation
  end

  it 'ignores calling `delete` with symbol' do
    inspect_source('some_hash.delete(:code)')
    expect(cop).not_to raise_violation
  end

  it 'ignores calling `delete` with string' do
    inspect_source('string.delete("-")')
    expect(cop).not_to raise_violation
  end

  it 'ignores calling `delete` with multiple args' do
    inspect_source('some.delete(1, header: [])')
    expect(cop).not_to raise_violation
  end

  it 'ignores calling `delete` on files-like variables' do
    inspect_source('tempfile.delete')
    expect(cop).not_to raise_violation
  end
end
