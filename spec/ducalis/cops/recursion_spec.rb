# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/recursion'

RSpec.describe Ducalis::Recursion do
  subject(:cop) { described_class.new }

  it '[rule] raises when method calls itself' do
    inspect_source(
      [
        'def set_rand_password',
        '  password = SecureRandom.urlsafe_base64(PASSWORD_LENGTH)',
        '  return set_rand_password unless password.match(PASSWORD_REGEX)',
        'end'
      ]
    )
    expect(cop).to raise_violation(/recursion/)
  end

  it 'raises when method calls itself with `self`' do
    inspect_source(
      [
        'def set_rand_password',
        '  password = SecureRandom.urlsafe_base64(PASSWORD_LENGTH)',
        '  return self.set_rand_password unless password.match(PASSWORD_REGEX)',
        'end'
      ]
    )
    expect(cop).to raise_violation(/recursion/)
  end

  it 'ignores empty methods' do
    inspect_source(
      [
        'def set_rand_password',
        'end'
      ]
    )
    expect(cop).to_not raise_violation
  end

  it 'ignores when code delegated to another method' do
    inspect_source(
      [
        'def set_rand_password',
        '  password = SecureRandom.urlsafe_base64(PASSWORD_LENGTH)',
        '  generate_password',
        'end'
      ]
    )
    expect(cop).to_not raise_violation
  end

  it '[rule] better to use lazy enumerations' do
    inspect_source(
      [
        'def repeatedly',
        '  Enumerator.new do |yielder|',
        '    loop { yielder.yield(yield) }',
        '  end',
        'end',
        '',
        'repeatedly { SecureRandom.urlsafe_base64(PASSWORD_LENGTH) }',
        '     .find { |password| password.match(PASSWORD_REGEX) }'
      ]
    )
    expect(cop).to_not raise_violation
  end
end
