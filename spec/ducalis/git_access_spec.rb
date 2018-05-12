# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/git_access'

RSpec.describe GitAccess do
  subject { described_class.instance }

  let(:diff) do
    instance_double(Git::Diff::DiffFile, type: 'created', path: 'path')
  end

  describe '::MODES' do
    let(:git) { instance_double(Git::Base) }

    it ':branch returns branch diff' do
      expect(git).to receive(:diff).with('origin/master')
      GitAccess::MODES[:branch].call(git)
    end

    it ':index returns diff between head and current state' do
      expect(git).to receive(:diff).with('HEAD')
      GitAccess::MODES[:index].call(git)
    end
  end

  describe '#store_pull_request!' do
    it 'allows to set PR information' do
      subject.store_pull_request!(['repo', 42])
      expect(subject.repo).to eq('repo')
      expect(subject.id).to eq(42)
    end
  end

  describe '#changed_files' do
    before do
      stub_const('GitAccess::MODES', current: ->(_) { [diff] })
      allow(Dir).to receive(:pwd).and_return('/root')
      allow(Dir).to receive(:exist?).with('/root/.git').and_return(true)
    end

    it 'returns [] when nothing configured' do
      expect(subject.changed_files).to match_array([])
    end

    it 'raises error when flag passed but there is no git dir' do
      subject.flag = :non_default
      expect(Dir).to receive(:exist?).with('/root/.git').and_return(false)
      expect { subject.changed_files }.to raise_error(Ducalis::MissingGit)
    end

    it 'returns changed files based on passed flag' do
      subject.flag = :current
      expect(Git).to receive(:open).with('/root')
      expect(File).to receive(:exist?).with('path').and_return(true)
      expect(subject.changed_files).to match_array(%w[path])
    end
  end

  describe '#for' do
    before { expect(subject).to receive(:changes).and_return([diff]) }

    it 'returns diff for passed path' do
      expect(subject.for('path')).to eq(diff)
    end

    it 'returns nil diff for unknown path' do
      expect(subject.for('unknown_path').patch_line).to eq(-1)
    end
  end
end
