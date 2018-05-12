# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/rest_only_cop.rb'

RSpec.describe Ducalis::RestOnlyCop do
  subject(:cop) { described_class.new }

  it '[rule] raises for controllers with non-REST methods' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index; end',
                     '  def order; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/REST/)
  end

  it '[rule] better to use only REST methods and create new controllers' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index; end',
                     'end',
                     '',
                     'class OrdersController < ApplicationController',
                     '  def create; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores controllers with private non-REST methods' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def recalculate; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores controllers with only REST methods' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index; end',
                     '  def show; end',
                     '  def new; end',
                     '  def edit; end',
                     '  def create; end',
                     '  def update; end',
                     '  def destroy; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores non-controllers with non-REST methods' do
    inspect_source([
                     'class PriceStore',
                     '  def index; end',
                     '  def recalculate; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
