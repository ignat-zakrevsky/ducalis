# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/adapters/default'

RSpec.describe Adapters::Default do
  describe '#self.suitable_for?' do
    it 'always return true' do
      expect(described_class.suitable_for?('literally any value')).to be true
    end
  end

  describe '#call' do
    it "split's PR info to repo and id" do
      expect(
        described_class.new('org/repo#42').call
      ).to match_array(['org/repo', '42'])
    end
  end
end
