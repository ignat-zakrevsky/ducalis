# frozen_string_literal: true

require 'rubocop'
require 'regexp-examples'

module Ducalis
  class RegexCop < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It's better to move regex to constants with example instead of direct using it. It will allow you to reuse this regex and provide instructions for others.

      | Example:

      | ```ruby
      | CONST_NAME = %<constant>s # "%<example>s"
      | %<fixed_string>s
      | ```

    MESSAGE

    SELF_DESCRIPTIVE = %w(
      /[[:alnum:]]/
      /[[:alpha:]]/
      /[[:blank:]]/
      /[[:cntrl:]]/
      /[[:digit:]]/
      /[[:graph:]]/
      /[[:lower:]]/
      /[[:print:]]/
      /[[:punct:]]/
      /[[:space:]]/
      /[[:upper:]]/
      /[[:xdigit:]]/
      /[[:word:]]/
      /[[:ascii:]]/
    ).freeze

    DETAILS = "Available regexes are:
      #{SELF_DESCRIPTIVE.map { |name| "`#{name}`" }.join(', ')}".freeze

    DEFAULT_EXAMPLE = 'some_example'.freeze

    def on_begin(node)
      not_defined_regexes(node).each do |regex|
        next if SELF_DESCRIPTIVE.include?(regex.source) || const_dynamic?(regex)
        add_offense(regex, :expression, format(OFFENSE, present_node(regex)))
      end
    end

    private

    def_node_search :const_using, '(regexp $_ ... (regopt))'
    def_node_search :const_definition, '(casgn ...)'

    def not_defined_regexes(node)
      const_using(node).reject do |regex|
        defined_as_const?(regex, const_definition(node))
      end.map(&:parent)
    end

    def defined_as_const?(regex, definitions)
      definitions.any? { |node| const_using(node).any? { |use| use == regex } }
    end

    def const_dynamic?(node)
      node.child_nodes.any?(&:begin_type?)
    end

    def present_node(node)
      {
        constant: node.source,
        fixed_string: node.source_range.source_line
                          .sub(node.source, 'CONST_NAME').lstrip,
        example: regex_sample(node)
      }
    end

    def regex_sample(node)
      Regexp.new(node.to_a.first.to_a.first).examples.sample
    rescue RegexpExamples::IllegalSyntaxError
      DEFAULT_EXAMPLE
    end
  end
end
