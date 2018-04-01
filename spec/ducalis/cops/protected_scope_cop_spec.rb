# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/protected_scope_cop'

RSpec.describe Ducalis::ProtectedScopeCop do
  subject(:cop) { described_class.new }

  it '[rule] raises if somewhere AR search was called on not protected scope' do
    inspect_source('Group.find(8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it '[rule] better to search records on protected scopes' do
    inspect_source('current_user.groups.find(8)')
    expect(cop).not_to raise_violation
  end

  it 'raises if AR search was called even for chain of calls' do
    inspect_source('Group.includes(:profiles).find(8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'raises if AR search was called with find_by id' do
    inspect_source('Group.includes(:profiles).find_by(id: 8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'raises if AR search was called on unnamespaced constant' do
    inspect_source('::Group.find(8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'ignores where statements and still raises error' do
    inspect_source(
      'Group.includes(:profiles).where(name: "John").find(8)'
    )
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'ignores find method with passed block' do
    inspect_source('MAPPING.find { |x| x == 42 }')
    expect(cop).not_to raise_violation
  end

  it 'ignores find method with passed multiline block' do
    inspect_source([
                     'MAPPING.find do |x|',
                     '  x == 42',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
