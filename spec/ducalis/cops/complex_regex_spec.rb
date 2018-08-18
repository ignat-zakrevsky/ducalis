# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/complex_regex'

SingleCov.covered!

RSpec.describe Ducalis::ComplexRegex do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'MaxComplexity' => 3 } }
  before { allow(cop).to receive(:cop_config).and_return(cop_config) }

  it '[rule] raises for regex with a lot of quantifiers' do
    inspect_source([
                     "PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./",
                     "AGE_RANGE_MATCH = /^(\d+)(?:-)(\d+)$/",
                     "FLOAT_NUMBER_REGEX = /(\d+,\d+.\d+|\d+[.,]\d+|\d+)/"
                   ])
    expect(cop).to raise_violation(/long form/, count: 3)
  end

  it '[rule] better to use long form with comments' do
    inspect_source([
                     'COMPLEX_REGEX = %r{',
                     '  start         # some text',
                     "  \s            # white space char",
                     '  (group)       # first group',
                     '  (?:alt1|alt2) # some alternation',
                     '  end',
                     '}x',
                     'LOG_FORMAT = %r{',
                     "  (\d{2}:\d{2}) # Time",
                     "  \s(\w+)       # Event type",
                     "  \s(.*)        # Message",
                     '}x'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'accepts simple regexes as is' do
    inspect_source([
                     "IDENTIFIER = /TXID:\d+/",
                     "REGEX_ONLY_NINE_DIGITS = /^\d{9}$/",
                     'ALPHA_ONLY = /[a-zA-Z]+/'
                   ])
    expect(cop).not_to raise_violation
  end
end
