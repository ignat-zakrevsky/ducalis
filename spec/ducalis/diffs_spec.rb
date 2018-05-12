# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/diffs'

RSpec.describe Diffs do
  subject do
    class FakeClass
      include Diffs

      def base_diff(diff, path)
        BaseDiff.new(diff, path)
      end

      def nil_diff(diff, path)
        NilDiff.new(diff, path)
      end

      def git_diff(diff, path)
        GitDiff.new(diff, path)
      end
    end
    FakeClass.new
  end

  let(:diff) { instance_double(Git::Diff::DiffFile, patch: 'diff') }

  describe 'BaseDiff' do
    let(:base_diff) { subject.base_diff(diff, 'path') }

    it 'allows to initialize diff with diff and path' do
      expect(base_diff.diff).to eq(diff)
      expect(base_diff.path).to eq('path')
    end
  end

  describe 'GitDiff' do
    let(:git_diff) { subject.git_diff(diff, 'path') }
    let(:patch)    { instance_double(Ducalis::Patch) }
    let(:line)     { double(:line, changed?: false, patch_position: 42) }

    before do
      expect(Ducalis::Patch).to receive(:new).and_return(patch)
      expect(patch).to receive(:line_for).with(32).and_return(line)
    end

    describe '#changed?' do
      it 'delegates to related diff line' do
        expect(git_diff.changed?(32)).to be false
      end
    end

    describe '#patch_line' do
      it 'delegates to related diff line' do
        expect(git_diff.patch_line(32)).to be 42
      end
    end
  end

  describe 'NilDiff' do
    let(:nil_diff) { subject.nil_diff(nil, nil) }

    describe '#changed?' do
      it 'always true' do
        expect(nil_diff.changed?).to be true
      end
    end

    describe '#patch_line' do
      it 'always -1' do
        expect(nil_diff.patch_line).to eq(-1)
      end
    end
  end
end
