# frozen_string_literal: true

ELVIS_SUPPORT_VERSION = 2.3

SingleCov.covered! uncovered:
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new(ELVIS_SUPPORT_VERSION)
    0
  else
    2 # on_csend method will be never called on Ruby < 2.3 =(
  end

require 'spec_helper'
require './lib/ducalis/cops/evlis_overusing'

RSpec.describe Ducalis::EvlisOverusing do
  let(:ruby_version) { ELVIS_SUPPORT_VERSION }
  subject(:cop) { described_class.new }

  it 'raises on multiple safe operator callings' do
    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new(ruby_version.to_s)
      inspect_source('user&.person&.full_name')
      expect(cop).to raise_violation(/overusing/)
    end
  end

  it '[rule] better to use NullObjects' do
    inspect_source([
                     'class NullManufacturer',
                     '  def contact',
                     '    "No Manufacturer"',
                     '  end',
                     'end',
                     '',
                     'def manufacturer',
                     '  product.manufacturer || NullManufacturer.new',
                     'end',
                     '',
                     'manufacturer.contact'
                   ])
    expect(cop).not_to raise_violation
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
