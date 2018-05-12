# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cli_arguments'

RSpec.describe Ducalis::CliArguments do
  subject { described_class.new }

  describe '#docs_command?' do
    it 'return true if ARGV contains doc command' do
      stub_const('ARGV', ['--docs'])
      expect(subject.docs_command?).to be true
    end
  end

  describe '#help_command?' do
    it 'return true if ARGV contains any help command' do
      stub_const('ARGV', ['-h'])
      expect(subject.help_command?).to be true
    end
  end

  describe '#process!' do
    let(:git_access)    { instance_double(GitAccess, repo: 'repo', id: 42) }
    let(:true_adapter)  { double(suitable_for?: true, call: %w[repo 42]) }
    let(:false_adapter) { double(suitable_for?: false) }

    before do
      stub_const('GitAccess', class_double(GitAccess, instance: git_access))
      stub_const('GitAccess::MODES', index: :_value)
    end

    it 'receiving git diff mode from ARGV' do
      stub_const('ARGV', ['--index'])
      expect(git_access).to receive(:flag=).with(:index)
      subject.process!
      expect(ARGV).to match_array([])
    end

    it "works when mode wasn't passed" do
      stub_const('ARGV', [])
      expect(git_access).to_not receive(:flag=)
      subject.process!
    end

    it 'receiving values for passed formatter' do
      stub_const('ARGV', ['--reporter', 'repo#42'])
      stub_const('Ducalis::CliArguments::ADAPTERS',
                 [false_adapter, true_adapter])
      expect(true_adapter).to receive(:new).with('repo#42')
                                           .and_return(true_adapter)
      expect(git_access).to receive(:store_pull_request!).with(%w[repo 42])
      subject.process!
      expect(ARGV).to match_array(['--format', 'GithubFormatter'])
    end
  end
end
