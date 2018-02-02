# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/standard_methods'

RSpec.describe Ducalis::StandardMethods do
  subject(:cop) { described_class.new }

  it '[rule] raises if use redefines default ruby methods' do
    inspect_source(cop, [
                     'def to_s',
                     '  "my version"',
                     'end'
                   ])
    expect(cop).to raise_violation(/redefine standard/)
  end

  it 'ignores if use defines simple ruby methods' do
    inspect_source(cop, [
                     'def present',
                     '  "my version"',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
