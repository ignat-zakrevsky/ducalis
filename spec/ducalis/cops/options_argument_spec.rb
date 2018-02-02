# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/options_argument'

RSpec.describe Ducalis::OptionsArgument do
  subject(:cop) { described_class.new }

  it '[rule] raises if method accepts default options argument' do
    inspect_source(cop, [
                     'def generate(document, options = {})',
                     '  format = options.delete(:format)',
                     '  limit = options.delete(:limit) || 20',
                     '  [format, limit, options]',
                     'end'
                   ])
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it '[rule] raises if method accepts options argument' do
    inspect_source(cop, [
                     'def log(record, options)',
                     '  # ...',
                     'end'
                   ])
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'raises if method accepts args argument' do
    inspect_source(cop, [
                     'def log(record, args)',
                     '  # ...',
                     'end'
                   ])
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'ignores passing options with split operator' do
    inspect_source(cop, [
                     'def generate(document, format:, limit: 20, **options)',
                     '  [format, limit, options]',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
