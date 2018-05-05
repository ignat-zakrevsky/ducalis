# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/descriptive_block_names'

RSpec.describe Ducalis::DescriptiveBlockNames do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'MinimalLenght' => 3, 'WhiteList' => %w[id] } }
  before { allow(cop).to receive(:cop_config).and_return(cop_config) }

  it '[rule] raises for blocks with one/two chars names' do
    inspect_source([
                     'employees.map { |e| e.call(some, word) }',
                     'cards.each    { |c| c.date = dates[c.id] }',
                     'Tempfile.new("name.pdf").tap do |f|',
                     '  f.binmode',
                     '  f.write(code)',
                     '  f.close',
                     'end'
                   ])
    expect(cop).to raise_violation(/descriptive names/, count: 3)
  end

  it '[rule] better to use descriptive names' do
    inspect_source([
                     'employees.map { |employee| employee.call(some, word) }',
                     'cards.each    { |card| card.date = dates[card.id] }',
                     'Tempfile.new("name.pdf").tap do |file|',
                     '  file.binmode',
                     '  file.write(code)',
                     '  file.close',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores records from whitelist' do
    inspect_source('people_ids.each { |id| puts(id) }')
    expect(cop).not_to raise_violation
  end

  it 'ignores variables which start with underscore' do
    inspect_source('people_ids.each { |_| puts "hi" }')
    expect(cop).not_to raise_violation
  end
end
