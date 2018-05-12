# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/possible_tap'

RSpec.describe Ducalis::PossibleTap do
  subject(:cop) { described_class.new }

  it '[rule] raises for methods with scope variable return' do
    inspect_source([
                     'def load_group',
                     '  group = channel.groups.find(params[:group_id])',
                     '  authorize group, :edit?',
                     '  group',
                     'end'
                   ])
    expect(cop).to raise_violation(/tap/)
  end

  it '[rule] better to use tap to increase code readability' do
    inspect_source([
                     'def load_group',
                     '  channel.groups.find(params[:group_id]) do |group|',
                     '    authorize group, :edit?',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises for methods with instance variable changes and return' do
    inspect_source([
                     'def load_group',
                     '  @group = Group.find(params[:id])',
                     '  authorize @group',
                     '  @group',
                     'end'
                   ])
    expect(cop).to raise_violation(/tap/)
  end

  it 'raises for methods with instance variable `||=` assign and return' do
    inspect_source([
                     'def define_roles',
                     '  return [] unless employee',
                     '',
                     '  @roles ||= []',
                     '  @roles << "primary"  if employee.primary?',
                     '  @roles << "contract" if employee.contract?',
                     '  @roles',
                     'end'
                   ])
    expect(cop).to raise_violation(/tap/)
  end

  it 'raises for methods which return call on scope variable' do
    inspect_source([
                     'def load_group',
                     '  elections = @elections.group_by(&:code)',
                     '  result = elections.map do |code, elections|',
                     '    { code => statistic }',
                     '  end',
                     '  result << total_spend(@elections)',
                     '  result.inject(:merge)',
                     'end'
                   ])
    expect(cop).to raise_violation(/tap/)
  end

  it 'raises for methods which return instance variable but have scope vars' do
    inspect_source([
                     'def generate_file(file_name)',
                     '  @file = Tempfile.new([file_name, ".pdf"])',
                     '  signed_pdf = some_new_stuff',
                     '  @file.write(signed_pdf.to_pdf)',
                     '  @file.close',
                     '  @file',
                     'end'
                   ])
    expect(cop).to raise_violation(/tap/)
  end

  it 'ignores empty methods' do
    inspect_source([
                     'def edit',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores methods which body is just call' do
    inspect_source([
                     'def total_cost(cost_field)',
                     '  Service.cost_sum(cost_field)',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores methods which return some statement' do
    inspect_source([
                     'def stop_terminated_employee',
                     '  if current_user && current_user.terminated?',
                     '    sign_out current_user',
                     '    redirect_to new_user_session_path',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it '[bugfix] calling methods on possible tap variable' do
    inspect_source([
                     'def create_message_struct(message)',
                     '  objects = message.map { |object| process(object) }',
                     '  Auditor::Message.new(message.process, objects)',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it '[bugfix] methods which simply returns instance var without changes' do
    inspect_source([
                     'def employee',
                     '  @employee',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it '[bugfix] methods which ends with if condition' do
    inspect_source([
                     'def complete=(value, complete_at)',
                     '  value = value.to_b',
                     '  self.complete_at = complete_at if complete && value',
                     '  self.complete_at = nil unless value',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it '[bugfix] methods with args without children nodes' do
    inspect_source([
                     'def filtered_admins(reducers)',
                     '  reducers',
                     '    .map { |reducer| @base_scope.public_send(reducer) }',
                     '    .order("admin_users.created_at DESC")',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
