# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class UnlockedGem < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It's better to lock gem versions explicitly with pessimistic operator (~>).
    MESSAGE

    def investigate(processed_source)
      return unless processed_source.ast

      gem_declarations(processed_source.ast).select do |node|
        _, _, gemname, _args = *node
        add_offense(node, :selector,
                    format(OFFENSE, gem: gemname.loc.expression.source))
      end
    end

    def_node_search :gem_declarations, '(send _ :gem (str _))'
  end
end
