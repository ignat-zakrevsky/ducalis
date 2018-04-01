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

  it '[rule] better to use builder classes for complex workflows' do
    inspect_source([
                     'class Product < ActiveRecord::Base',
                     'end',
                     '',
                     'class ProductCreation',
                     '  def initialize(attributes)',
                     '    @attributes = attributes',
                     '  end',
                     '',
                     '  def create',
                     '    Product.create(@attributes).tap do |product|',
                     '      generate_code(product)',
                     '    end',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def generate_code(product)',
                     '    # logic goes here',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores non-ActiveRecord classes which contains callbacks' do
    inspect_source([
                     'class Product < BasicProduct',
                     '  before_create :generate_code',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
