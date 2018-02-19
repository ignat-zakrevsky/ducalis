# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/callbacks_activerecord'

RSpec.describe Ducalis::CallbacksActiverecord do
  subject(:cop) { described_class.new }

  it '[rule] raises on ActiveRecord classes which contains callbacks' do
    inspect_source([
                     'class Product < ActiveRecord::Base',
                     '  before_create :generate_code',
                     'end'
                   ])
    expect(cop).to raise_violation(/callbacks/)
  end

  it 'ignores non-ActiveRecord classes which contains callbacks' do
    inspect_source([
                     'class Product < BasicProduct',
                     '  before_create :generate_code',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
