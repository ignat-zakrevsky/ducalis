# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/regex_cop'

RSpec.describe Ducalis::RegexCop do
  subject(:cop) { described_class.new }

  it 'raises if somewhere in code used regex which is not moved to const' do
    inspect_source(cop, [
                     'name = "john"',
                     'puts "hi" if name =~ /john/'
                   ])

    expect(cop).to raise_violation(%r{CONST_NAME = /john/ # "john"})
    expect(cop).to raise_violation(/puts "hi" if name =~ CONST_NAME/)
  end

  it 'raises if somewhere in code used regex but defined another const' do
    inspect_source(cop, [
                     'ANOTHER_CONST = /ivan/',
                     'puts "hi" if name =~ /john/'
                   ])
    expect(cop).to raise_violation(/puts "hi"/)
  end

  it 'ignores matching constants' do
    inspect_source(cop, [
                     'REGEX = /john/',
                     'name = "john"',
                     'puts "hi" if name =~ REGEX'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores freeze calling' do
    inspect_source(cop, [
                     'REGEX = /john/.freeze',
                     'puts "hi" if name =~ REGEX'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores named ruby constants' do
    inspect_source(cop, [
                     'name = "john"',
                     'puts "hi" if name =~ /[[:alpha:]]/'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores dynamic regexs' do
    inspect_source(cop, [
                     'name = "john"',
                     'puts "hi" if name =~ /.{#{name.length}}/'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'rescue dynamic regexes dynamic regexs' do
    inspect_source(cop, [
                     'name = "john"',
                     'puts "hi" if name =~ /foo(?=bar)/'
                   ])
    expect(cop).to raise_violation(
      %r{CONST_NAME = /foo\(\?=bar\)/ # "some_example"}
    )
  end
end
