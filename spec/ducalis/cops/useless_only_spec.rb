# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/useless_only.rb'

RSpec.describe Ducalis::UselessOnly do
  subject(:cop) { described_class.new }

  it '[rule] raises for `before_filters` with only one method' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost, only: [:index]',
                     '',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it '[rule] better to inline calls for instead of moving it to only' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    update_cost',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises for `before_filters` with only one method as keyword array' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost, only: %i[index]',
                     '',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'raises for `before_filters` with many actions and only one method' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost, :load_me, only: %i[index]',
                     '',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     '  def load_me; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'raises for `before_filters` with only one method as argument' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost, only: :index',
                     '',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'ignores `before_filters` without arguments' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost',
                     '',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores `before_filters` with `only` and many arguments' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost, only: %i[index show]',
                     '',
                     '  def index; end',
                     '  def show; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores `before_filters` with `except` and one argument' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  before_filter :update_cost, except: %i[index]',
                     '',
                     '  def index; end',
                     '',
                     '  private',
                     '',
                     '  def update_cost; end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
