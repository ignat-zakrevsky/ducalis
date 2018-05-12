# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/github_formatter'

RSpec.describe GithubFormatter do
  subject { described_class.new(nil) }

  describe '#started' do
    it 'initializes offenses accumulator' do
      expect do
        subject.started([])
      end.to change { subject.all }.from(nil).to([])
    end
  end

  describe '#file_finished' do
    before do
      subject.started([])
      expect(subject).to receive(:print).with('.')
    end

    it 'pushes offenses to accumulator' do
      expect do
        subject.file_finished(:file, %i[result])
      end.to change { subject.all }.from([]).to([%i[result]])
    end

    it 'ignores empty offenses' do
      expect do
        subject.file_finished(:file, [])
      end.to_not(change { subject.all })
    end
  end

  describe '#finished' do
    let(:git_access)  { instance_double(GitAccess, repo: 'repo', id: 42) }
    let(:commentator) { instance_double(Ducalis::Commentators::Github) }

    before do
      expect(subject).to receive(:print).twice.with('.')
      expect(subject).to receive(:print).with("\n")

      subject.started([])
      subject.file_finished(:file, %i[result1])
      subject.file_finished(:file, %i[result2 result3])
    end

    it 'push files to ducalis commentator' do
      stub_const('GitAccess', class_double(GitAccess, instance: git_access))
      expect(
        Ducalis::Commentators::Github
      ).to receive(:new).with('repo', 42)
                        .and_return(commentator)
      expect(
        commentator
      ).to receive(:call).with(%i[result1 result2 result3])
      subject.finished([])
    end
  end
end
