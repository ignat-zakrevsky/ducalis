# frozen_string_literal: true

require 'rubocop'
require 'regexp_parser'

module Ducalis
  class ComplexRegex < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It seems like this regex is a little bit complex. It's better to increase code readability by using long form with "\\x".
    MESSAGE
    DEFAULT_COST = 0
    COMPLEX_TYPES_COSTS = {
      quantifier: 1,
      meta: 1,
      assertion: 1,
      group: 0.5
    }.freeze

    def on_begin(node)
      regex_using(node).each do |regex_desc|
        next if formatted?(regex_desc) || simple?(regex_desc.first)

        add_offense(regex_desc.first, :expression, OFFENSE)
      end
    end

    private

    def simple?(regex_node)
      Regexp::Scanner.scan(
        Regexp.new(regex_node.source)
      ).map do |type, _, _, _, _|
        COMPLEX_TYPES_COSTS.fetch(type, DEFAULT_COST)
      end.inject(:+) <= maximal_complexity
    end

    def maximal_complexity
      cop_config['MaxComplexity']
    end

    def formatted?(regex_desc)
      regex_desc.size > 1
    end

    def_node_search :regex_long_form?, '(regopt :x)'
    def_node_search :regex_using, '(regexp $... (regopt ...))'
  end
end
