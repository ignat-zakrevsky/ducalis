# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/errors'

RSpec.describe Ducalis::Utils do
  describe '#ochokit' do
    let(:token) { '7103donotforgettoremovemefromgit' }
    let(:client) { instance_double(OchoKit) }

    it 'raises missing token error when there is no key in ENV' do
      stub_const('ENV', {})
      expect { described_class.ochokit }.to raise_error(Ducalis::MissingToken)
    end

    it 'returns configured ochokit version' do
      stub_const('ENV', 'GITHUB_TOKEN' => token)
      expect(OchoKit).to receive(:new).with(access_token: token)
                                              .and_return(client)
      described_class.ochokit
    end
  end

  describe '#similarity' do
    it 'returns 1 for equal strings' do
      expect(
        described_class.similarity('aaa', 'aaa')
      ).to be_within(0.01).of(1.0)
    end

    it 'returns 0 for fully different strings' do
      expect(
        described_class.similarity('aaa', 'zzz')
      ).to be_within(0.01).of(0)
    end

    it 'returns similarity score for strings' do
      expect(
        described_class.similarity('aabb', 'aazz')
      ).to be_within(0.01).of(0.5)
    end
  end

  describe '#silence_warnings' do
    it 'allows to change constants without warning' do
      SPEC_CONST = 1
      expect do
        described_class.silence_warnings { SPEC_CONST = 2 }
      end.to_not output.to_stderr
    end
  end
end
