# frozen_string_literal: true

RSpec::Matchers.define :raise_violation do |like, count: 1|
  match do |cop|
    cop.offenses.size == count && cop.offenses.first.message.match(like)
  end

  match_when_negated do |cop|
    cop.offenses.empty?
  end
end
