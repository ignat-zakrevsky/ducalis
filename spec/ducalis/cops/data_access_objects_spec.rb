# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/data_access_objects'

RSpec.describe Ducalis::DataAccessObjects do
  subject(:cop) { described_class.new }

  it '[rule] raises on working with `session` object' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def edit',
                     '    session[:start_time] = Time.now',
                     '  end',
                     '',
                     '  def update',
                     '    @time = Date.parse(session[:start_time]) - Time.now',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/Data Access/, count: 2)
  end

  it '[rule] better to use DAO objects' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def edit',
                     '    session_time.start!',
                     '  end',
                     '',
                     '  def update',
                     '    @time = session_time.period',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def session_time',
                     '    @_session_time ||= SessionTime.new(session)',
                     '  end',
                     'end',
                     '',
                     'class SessionTime',
                     '  KEY = :start_time',
                     '',
                     '  def initialize(session)',
                     '    @session = session',
                     '    @current_time = Time.now',
                     '  end',
                     '',
                     '  def start!',
                     '    @session[KEY] = @current_time',
                     '  end',
                     '',
                     '  def period',
                     '    Date.parse(@session[KEY]) - @current_time',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises on working with `cookies` object' do
    inspect_source([
                     'class HomeController < ApplicationController',
                     '  def set_cookies',
                     '    cookies[:user_name] = "Horst Meier"',
                     '    cookies[:customer_number] = "1234567890"',
                     '  end',
                     '',
                     '  def show_cookies',
                     '    @user_name = cookies[:user_name]',
                     '    @customer_number = cookies[:customer_number]',
                     '  end',
                     '',
                     '  def delete_cookies',
                     '    cookies.delete :user_name',
                     '    cookies.delete :customer_number',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/Data Access/, count: 6)
  end

  it 'raises on working with global `$redis` object' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def update',
                     '    $redis.incr("current_hits")',
                     '  end',
                     '',
                     '  def show',
                     '    $redis.get("current_hits").to_i',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/Data Access/, count: 2)
  end

  it 'raises on working with `Redis.current` object' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def update',
                     '    Redis.current.incr("current_hits")',
                     '  end',
                     '',
                     '  def show',
                     '    Redis.current.get("current_hits").to_i',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/Data Access/, count: 2)
  end

  it 'ignores passing DAO-like objects to services' do
    inspect_source([
                     'class ProductsController < ApplicationController',
                     '  def update',
                     '    current_hits.increment',
                     '  end',
                     '',
                     '  def show',
                     '    current_hits.count',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def current_hits',
                     '    @_current_hits ||= CurrentHits.new(Redis.current)',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores non-controller classes `$redis` object' do
    inspect_source([
                     'class ProductsDAO',
                     '  def update',
                     '    $redis.incr("current_hits")',
                     '  end',
                     '',
                     '  def show',
                     '    $redis.get("current_hits").to_i',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
