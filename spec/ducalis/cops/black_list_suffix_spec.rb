# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/black_list_suffix'

RSpec.describe Ducalis::BlackListSuffix do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'BlackList' => ['Sorter'] } }
  before { allow(cop).to receive(:cop_config).and_return(cop_config) }

  it '[rule] raises on classes with suffixes from black list' do
    inspect_source(cop, [
                     'class ListSorter',
                     'end'
                   ])
    expect(cop).to raise_violation(/class suffixes/)
  end

  it 'ignores classes with okish suffixes' do
    inspect_source(cop, [
                     'class SortedList',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores classes with full match' do
    inspect_source(cop, [
                     'class Manager',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
