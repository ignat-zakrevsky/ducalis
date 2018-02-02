# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/enforce_namespace'

RSpec.describe Ducalis::EnforceNamespace do
  subject(:cop) { described_class.new }
  before { allow(cop).to receive(:in_service?).and_return true }

  it '[rule] raises on classes without namespace' do
    inspect_source(cop, 'class MyService; end')
    expect(cop).to raise_violation(/namespace/)
  end

  it '[rule] raises on modules without namespace' do
    inspect_source(cop, 'module MyServiceModule; end')
    expect(cop).to raise_violation(/namespace/)
  end

  it 'ignores alone class with namespace' do
    inspect_source(cop, 'module My; class Service; end; end')
    expect(cop).to_not raise_violation
  end

  it 'ignores multiple classes with namespace' do
    inspect_source(cop, 'module My; class Service; end; class A; end; end')
    expect(cop).to_not raise_violation
  end
end
