# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/case_mapping'

RSpec.describe Ducalis::CaseMapping do
  subject(:cop) { described_class.new }

  it '[rule] raises on case statements' do
    inspect_source([
                     'case grade',
                     'when "A"',
                     '  puts "Well done!"',
                     'when "B"',
                     '  puts "Try harder!"',
                     'when "C"',
                     '  puts "You need help!!!"',
                     'else',
                     '  puts "You just making it up!"',
                     'end'
                   ])
    expect(cop).to raise_violation(/case/)
  end

  it '[rule] better to use mapping' do
    inspect_source([
                     '{',
                     '  "A" => "Well done!",',
                     '  "B" => "Try harder!",',
                     '  "C" => "You need help!!!",',
                     '}.fetch(grade) { "You just making it up!" }'
                   ])
    expect(cop).not_to raise_violation
  end
end
