# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class KeywordDefaults < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Prefer to use keyword arguments for defaults. It increases readability and reduces ambiguities.
      | It is ok if an argument is single and the name obvious from the function declaration.
    MESSAGE

    def on_def(node)
      args = node.type == :defs ? node.to_a[2] : node.to_a[1]

      return if args.to_a.one?

      args.children.each do |arg_node|
        next unless arg_node.type == :optarg

        add_offense(node, :expression, OFFENSE)
      end
    end
    alias on_defs on_def
  end
end
