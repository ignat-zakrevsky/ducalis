# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class ComplexStatements < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, refactor this complex statement to a method with a meaningful name.
    MESSAGE
    MAXIMUM_OPERATORS = 2

    def on_if(node)
      return if bool_operator(node).count < MAXIMUM_OPERATORS

      add_offense(node, :expression, OFFENSE)
    end

    def_node_search :bool_operator, '({and or} ...)'
  end
end
