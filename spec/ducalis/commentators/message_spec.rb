# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/commentators/message'

RSpec.describe Ducalis::Commentators::Message do
  subject { described_class.new(offense) }
  let(:offense) do
    instance_double(RuboCop::Cop::Offense, message: message, cop_name: cop_name)
  end
  let(:cop_name) { 'Ducalis/ProtectedScopeCop' }

  context 'with new messages format (which contains copname)' do
    let(:message) { 'Ducalis/ProtectedScopeCop: A long description.' }

    it 'comments offenses with link to the cop desc', :aggregate_failures do
      expect(subject.with_link).to include('ducalis-rb')
      expect(subject.with_link).to include('#ducalisprotectedscopecop')
      expect(subject.with_link).to include('A long description.')
    end
  end

  context 'with old messages format' do
    let(:message) { 'A long description.' }

    it 'comments offenses with link to the cop desc', :aggregate_failures do
      expect(subject.with_link).to include('ducalis-rb')
      expect(subject.with_link).to include('#ducalisprotectedscopecop')
      expect(subject.with_link).to include('A long description.')
    end
  end
end
