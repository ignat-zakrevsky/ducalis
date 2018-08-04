# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/facade_pattern'

RSpec.describe Ducalis::FacadePattern do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'MaxInstanceVariables' => 4 } }
  before { allow(cop).to receive(:cop_config).and_return(cop_config) }

  it '[rule] raises on working with `session` object' do
    inspect_source([
                     'class DashboardsController < ApplicationController',
                     '  def index',
                     '    @group = current_group',
                     '    @relationship_manager = @group.relationship_manager',
                     '    @contract_signer = @group.contract_signer',
                     '',
                     '    @statistic = EnrollmentStatistic.for(@group)',
                     '    @tasks = serialize(@group.tasks, ' \
                     'serializer: TaskSerializer)',
                     '    @external_links = @group.external_links',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/Facade/)
  end

  it '[rule] better to use facade pattern' do
    inspect_source([
                     'class Dashboard',
                     '  def initialize(group)',
                     '    @group',
                     '  end',
                     '',
                     '  def external_links',
                     '    @group.external_links',
                     '  end',
                     '',
                     '  def tasks',
                     '    serialize(@group.tasks, serializer: TaskSerializer)',
                     '  end',
                     '',
                     '  def statistic',
                     '    EnrollmentStatistic.for(@group)',
                     '  end',
                     '',
                     '  def contract_signer',
                     '    @group.contract_signer',
                     '  end',
                     '',
                     '  def relationship_manager',
                     '    @group.relationship_manager',
                     '  end',
                     'end',
                     '',
                     'class DashboardsController < ApplicationController',
                     '  def index',
                     '    @dashboard = Dashboard.new(current_group)',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores private methods (I hope nobody will use it as a good example)' do
    inspect_source([
                     'class DashboardsController < ApplicationController',
                     '  private',
                     '',
                     '  def assing_variables',
                     '    @var_1 = 1',
                     '    @var_2 = 2',
                     '    @var_3 = 3',
                     '    @var_4 = 4',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
