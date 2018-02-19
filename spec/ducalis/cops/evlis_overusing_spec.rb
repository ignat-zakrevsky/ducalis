# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/evlis_overusing'

RSpec.describe Ducalis::EvlisOverusing do
  let(:ruby_version) { 2.3 }
  subject(:cop) { described_class.new }

  it '[rule] raises on multiple safe operator callings' do
    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new(ruby_version.to_s)
      inspect_source('user&.person&.full_name')
      expect(cop).to raise_violation(/overusing/)
    end
  end

  it '[rule] raises on multiple try callings' do
    inspect_source('product.try(:manufacturer).try(:contact)')
    expect(cop).to raise_violation(/overusing/)
  end

  it 'raises on multiple try! callings' do
    inspect_source('product.try!(:manufacturer).try!(:contact)')
    expect(cop).to raise_violation(/overusing/)
  end

  it 'raises on multiple safe try callings' do
    inspect_source('params[:account].try(:[], :owner).try(:[], :address)')
    expect(cop).to raise_violation(/overusing/)
  end
end
