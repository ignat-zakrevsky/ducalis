# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class EnforceNamespace < RuboCop::Cop::Cop
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Too improve code organization it is better to define namespaces to group services by high-level features, domains or any other dimension.
    MESSAGE

    def on_class(node)
      return if !node.parent.nil? || !in_service?
      add_offense(node, :expression, OFFENSE)
    end

    def on_module(node)
      return if !node.parent.nil? || !in_service?
      return if contains_class?(node) || contains_classes?(node)
      add_offense(node, :expression, OFFENSE)
    end

    def_node_search :contains_class?, '(module _ ({casgn module class} ...))'
    def_node_search :contains_classes?,
                    '(module _ (begin ({casgn module class} ...) ...))'
  end
end
