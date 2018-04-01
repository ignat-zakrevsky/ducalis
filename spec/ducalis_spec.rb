# frozen_string_literal: true

require 'ducalis/documentation'

RSpec.describe Ducalis do
  it 'has a version number' do
    expect(Ducalis::VERSION).not_to be nil
  end

  it 'has a positive and negative examples for each cop' do
    Documentation.new.cop_rules.each do |file, rules|
      check = has_word(rules, Documentation::SIGNAL_WORD) &&
              has_word(rules, Documentation::PREFER_WORD)
      expect(check).to be(true),
                       "expected #{file} has positive and negative cases"
    end
  end

  def has_word(rules, word)
    rules.any? { |(rule, _code)| rule.include?(word) }
  end
end
