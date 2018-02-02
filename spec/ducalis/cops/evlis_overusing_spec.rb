# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/evlis_overusing'

RSpec.describe Ducalis::EvlisOverusing do
  let(:ruby_version) { 2.3 }
  subject(:cop) { described_class.new }

  it '[rule] raises on multiple safe operator callings' do
    if cop.target_ruby_version >= ruby_version
      inspect_source(cop, 'user&.person&.full_name')
      expect(cop).to raise_violation(/overusing/)
    end
  end

  it '[rule] raises on multiple try callings' do
    inspect_source(cop, 'product.try(:manufacturer).try(:contact)')
    expect(cop).to raise_violation(/overusing/)
  end

  it 'raises on multiple try! callings' do
    inspect_source(cop, 'product.try!(:manufacturer).try!(:contact)')
    expect(cop).to raise_violation(/overusing/)
  end

  it 'raises on multiple safe try callings' do
    inspect_source(cop, 'params[:account].try(:[], :owner).try(:[], :address)')
    expect(cop).to raise_violation(/overusing/)
  end
end
