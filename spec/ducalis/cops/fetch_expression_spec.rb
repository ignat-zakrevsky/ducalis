# frozen_string_literal: true
require 'spec_helper'
require './lib/ducalis/cops/fetch_expression'

RSpec.describe Ducalis::FetchExpression do
  subject(:cop) { described_class.new }

  it '[rule] raises on using [] with default' do
    inspect_source(cop, 'params[:to] || destination')
    expect(cop).to raise_violation(/fetch/)
  end

  it '[rule] raises on using ternary operator with default' do
    inspect_source(cop, 'params[:to] ? params[:to] : destination')
    expect(cop).to raise_violation(/fetch/)
  end

  it 'raises on using ternary operator with nil?' do
    inspect_source(cop, 'params[:to].nil? ? destination : params[:to]')
    expect(cop).to raise_violation(/fetch/)
  end
end
