# frozen_string_literal: true

require 'rubocop'
require 'ducalis/cops/extensions/type_resolving'

module Ducalis
  class DataAccessObjects < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It's a good practice to move code related to serialization/deserialization out of the controller. Consider of creating Data Access Object to separate the data access parts from the application logic. It will eliminate problems related to refactoring and testing.
    MESSAGE

    NODE_EXPRESSIONS = [
      s(:send, nil, :session),
      s(:send, nil, :cookies),
      s(:gvar, :$redis),
      s(:send, s(:const, nil, :Redis), :current)
    ].freeze

    def on_send(node)
      return unless in_controller?
      return unless NODE_EXPRESSIONS.include?(node.to_a.first)
      add_offense(node, :expression, OFFENSE)
    end
  end
end
