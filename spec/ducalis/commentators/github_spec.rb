# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/commentators/github'

RSpec.describe Ducalis::Commentators::Github do
  subject { described_class.new('repo', 42) }

  before { stub_const('Ducalis::Utils', double(:utils, octokit: octokit)) }

  let(:octokit)  { instance_double(Octokit::Client) }

  let(:path)     { 'app/controllers/books_controller.rb' }
  let(:message)  { 'actual cop message with description' }
  let(:position) { 60 }
  let(:existing_comment) { { path: path, position: position, body: message } }

  let(:buffer) { instance_double(Parser::Source::Buffer, name: path) }
  let(:range)  { instance_double(Parser::Source::Range, source_buffer: buffer) }

  let(:message_extension) do
    instance_double(Ducalis::Commentators::Message, with_link: message)
  end
  let(:offense) do
    instance_double(RuboCop::Cop::Offense,
                    message: message, location: range, line: position)
  end

  context "when PR doesn't have any previous comments" do
    before do
      expect(Ducalis::Commentators::Message).to receive(:new).with(offense)
        .twice.and_return(message_extension)
      expect(octokit).to receive(:pull_request_comments).and_return([])
      expect(Dir).to receive(:pwd).exactly(8).times.and_return('')
    end

    it 'comments offenses' do
      expect(octokit).to receive(:create_pull_request_review)
      subject.call([offense])
    end
  end

  context 'when PR already commented but some offenses are not' do
    let(:nil_diff) { double(:diff, path: 'some/path', patch_line: -1) }

    before do
      expect(Ducalis::Commentators::Message).to receive(:new).with(offense)
        .twice.and_return(message_extension)
      expect(GitAccess.instance).to receive(:for)
        .with(path).exactly(4).times.and_return(nil_diff)
      expect(octokit).to receive(:pull_request_comments)
        .and_return([existing_comment])
    end

    it 'comments missed offenses' do
      expect(octokit).to receive(:create_pull_request_review)
      subject.call([offense])
    end
  end

  context 'when PR already commented with the same comment' do
    let(:git_diff) { double(:diff, path: path, patch_line: position) }

    before do
      expect(Ducalis::Commentators::Message).to receive(:new)
        .with(offense).and_return(message_extension)
      expect(GitAccess.instance).to receive(:for)
        .with(path).twice.and_return(git_diff)
      expect(octokit).to receive(:pull_request_comments)
        .and_return([existing_comment])
    end

    it "doesn't re-comment this PR" do
      expect(octokit).not_to receive(:create_pull_request_review)
      subject.call([offense])
    end
  end
end
