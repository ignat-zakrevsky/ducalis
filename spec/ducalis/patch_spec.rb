# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/patch'

RSpec.describe Ducalis::Patch do
  subject { described_class.new(diff) }

  let(:diff) { File.read('./spec/fixtures/patch.diff') }

  describe '#line_for' do
    it 'returns corresponding line description for existing files' do
      expect(subject.line_for(16).changed?).to be true
      expect(subject.line_for(16).patch_position).to eq(13)
    end

    it 'returns empty line for non-existing and non-changed files' do
      expect(subject.line_for(42).changed?).to be false
      expect(subject.line_for(42).patch_position).to eq(-1)
    end
  end
end
