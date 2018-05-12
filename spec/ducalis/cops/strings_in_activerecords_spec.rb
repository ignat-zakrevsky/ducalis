# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/strings_in_activerecords'

RSpec.describe Ducalis::StringsInActiverecords do
  subject(:cop) { described_class.new }

  it '[rule] raises for string if argument' do
    inspect_source([
                     'before_save :set_full_name, ',
                     " if: 'name_changed? || postfix_name_changed?'"
                   ])
    expect(cop).to raise_violation(/before_save/)
  end

  it '[rule] better to use lambda as argument' do
    inspect_source('validates :file, if: -> { remote_url.blank? }')
    expect(cop).not_to raise_violation
  end

  it 'works for block arguments' do
    inspect_source('before_save {}')
    expect(cop).not_to raise_violation
  end

  it 'works for lambda arguments' do
    inspect_source('after_destroy -> { run_after_commit { remove_pages } }')
    expect(cop).not_to raise_violation
  end

  it 'ignores validates with other method invokes' do
    inspect_source('validates :file, presence: true')
    expect(cop).not_to raise_violation
  end
end
