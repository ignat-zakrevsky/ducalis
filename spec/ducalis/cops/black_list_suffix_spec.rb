# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/black_list_suffix'

RSpec.describe Ducalis::BlackListSuffix do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'BlackList' => ['Sorter'] } }
  before { allow(cop).to receive(:cop_config).and_return(cop_config) }

  it '[rule] raises on classes with suffixes from black list' do
    inspect_source([
                     'class ListSorter',
                     'end'
                   ])
    expect(cop).to raise_violation(/class suffixes/)
  end

  it '[rule] better to have names which map on business-logic' do
    inspect_source([
                     'class SortedList',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores classes with full match' do
    inspect_source([
                     'class Manager',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
