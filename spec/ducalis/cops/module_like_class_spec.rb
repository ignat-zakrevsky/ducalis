# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/module_like_class'

RSpec.describe Ducalis::ModuleLikeClass do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'AllowedIncludes' => ['Singleton'] } }

  it '[rule] raises for class without constructor but accepts the same args' do
    inspect_source([
                     'class TaskJournal',
                     '  def initialize(customer)',
                     '    # ...',
                     '  end',
                     '',
                     '  def approve(task, estimate, options)',
                     '    # ...',
                     '  end',
                     '',
                     '  def decline(user, task, estimate, details)',
                     '    # ...',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def log(record)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/pass `task`, `estimate`/)
  end

  it '[rule] raises for class with only one public method with args' do
    inspect_source([
                     'class TaskJournal',
                     '  def approve(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def log(record)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/pass `task`/)
  end

  it 'ignores classes with custom includes' do
    allow(cop).to receive(:cop_config).and_return(cop_config)
    inspect_source([
                     'class TaskJournal',
                     '  include Singleton',
                     '',
                     '  def approve(task)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores classes with inheritance' do
    inspect_source([
                     'class TaskJournal < BasicJournal',
                     '  def approve(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def log(record)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores classes with one method and initializer' do
    inspect_source([
                     'class TaskJournal',
                     '  def initialize(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def call(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
