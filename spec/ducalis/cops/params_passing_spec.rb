# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/params_passing'

RSpec.describe Ducalis::ParamsPassing do
  subject(:cop) { described_class.new }

  it '[rule] raises if user pass `params` as argument from controller' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(params).log',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/preprocessed params/)
  end

  it '[rule] better to pass permitted params' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(record_params).log',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises if user pass `params` as any argument from controller' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(first_arg, params).log',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/preprocessed params/)
  end

  it 'raises if user pass `params` as keyword argument from controller' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(first_arg, any_name: params).log',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/preprocessed params/)
  end

  it 'ignores passing only one `params` field' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(first_arg, params[:id]).log',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores passing processed `params`' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(first_arg, params.slice(:name)).log',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores passing `params` from `arcane` gem' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def index',
                     '    Record.new(params.for(Log).as(user).refine).log',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
