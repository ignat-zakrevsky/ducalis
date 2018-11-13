# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class RubocopDisable < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, do not suppress RuboCop metrics, may be you can introduce some refactoring or another concept.
    MESSAGE

    def investigate(processed_source)
      return unless processed_source.ast

      processed_source.comments.each do |comment_node|
        next unless comment_node.loc.expression.source =~ /rubocop:disable/

        add_offense(comment_node, :expression, OFFENSE)
      end
    end
  end
end
