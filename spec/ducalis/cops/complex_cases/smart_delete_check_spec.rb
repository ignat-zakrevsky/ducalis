# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require 'parser/ast/node'
require './lib/ducalis/cops/complex_cases/smart_delete_check'

RSpec.describe ComplexCases::SmartDeleteCheck do
  let(:who) { instance_double(Parser::AST::Node) }
  let(:node) { instance_double(Parser::AST::Node) }

  describe '.call' do
    let(:check_kass) { instance_double(described_class, false_positive?: true) }

    it 'delegates false_positive calling with not' do
      expect(described_class).to receive(:new).and_return(check_kass)
      expect(described_class.call(:who, :what, :args)).to be false
    end
  end

  describe '#false_positive?' do
    context 'when string argument passed' do
      subject { described_class.new(who, nil, [node]) }

      it 'returns true' do
        expect(node).to receive(:type).and_return(:str)
        expect(subject.false_positive?).to be true
      end
    end

    context 'when there are many arguments' do
      subject { described_class.new(who, nil, [node, node]) }

      it 'returns true' do
        expect(node).to receive(:type).and_return(:non_string)
        expect(subject.false_positive?).to be true
      end
    end

    context 'when caller is whitelisted' do
      subject { described_class.new(who, nil, [node]) }

      it 'returns true' do
        expect(node).to receive(:type).and_return(:non_string)
        expect(who).to receive(:to_s).and_return('File')
        expect(subject.false_positive?).to be true
      end
    end
  end
end
