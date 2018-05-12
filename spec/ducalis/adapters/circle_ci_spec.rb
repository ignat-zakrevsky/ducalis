# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/adapters/circle_ci'

RSpec.describe Adapters::CircleCI do
  describe '#self.suitable_for?' do
    it 'returns true for `circleci` string' do
      expect(described_class.suitable_for?('circleci')).to be true
    end
  end

  describe '#call' do
    before do
      stub_const('ENV',
                 'CI_PULL_REQUEST' => 'https://github.com/org/repo/pull/42',
                 'CIRCLE_REPOSITORY_URL' => 'git@github.com:org/repo.git')
    end

    it 'parses info from ENV variables' do
      expect(described_class.new(nil).call).to match_array(['org/repo', '42'])
    end
  end
end
