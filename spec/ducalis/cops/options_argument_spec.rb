# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/options_argument'

RSpec.describe Ducalis::OptionsArgument do
  subject(:cop) { described_class.new }

  it '[rule] raises if method accepts default options argument' do
    inspect_source([
                     'def generate(document, options = {})',
                     '  format = options.delete(:format)',
                     '  limit = options.delete(:limit) || 20',
                     '  [format, limit, options]',
                     'end'
                   ])
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'raises if method accepts a options argument' do
    inspect_source([
                     'def log(record, options)',
                     '  # ...',
                     'end'
                   ])
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'raises if method accepts args argument' do
    inspect_source([
                     'def log(record, args)',
                     '  # ...',
                     'end'
                   ])
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it '[rule] better to pass options with the split operator' do
    inspect_source([
                     'def generate(document, format:, limit: 20, **options)',
                     '  [format, limit, options]',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
