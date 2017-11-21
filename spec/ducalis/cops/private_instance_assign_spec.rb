# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/private_instance_assign'

RSpec.describe Ducalis::PrivateInstanceAssign do
  subject(:cop) { described_class.new }

  it 'raises for assigning instance variables in controllers private methods' do
    inspect_source(cop, [
                     'class EmployeesController < ApplicationController',
                     '  private',
                     '',
                     '  def load_employee',
                     '    @employee = Employee.find(params[:id])',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/instance/)
  end

  it 'raises for memoization variables in controllers private methods' do
    inspect_source(cop, [
                     'class EmployeesController < ApplicationController',
                     '  private',
                     '',
                     '  def catalog',
                     '    @catalog ||= Catalog.new',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/underscore/)
  end

  it 'ignores memoization variables in controllers private methods with _' do
    inspect_source(cop, [
                     'class EmployeesController < ApplicationController',
                     '  private',
                     '',
                     '  def catalog',
                     '    @_catalog ||= Catalog.new',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores assigning instance variables in controllers public methods' do
    inspect_source(cop, [
                     'class EmployeesController < ApplicationController',
                     '  def index',
                     '    @employee = load_employee',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def load_employee',
                     '    Employee.find(params[:id])',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
