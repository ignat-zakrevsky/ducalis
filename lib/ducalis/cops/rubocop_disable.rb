# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class RubocopDisable < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, do not suppress RuboCop metrics, may be you can introduce some refactoring or another concept.
    MESSAGE

    MAGIC_SUBSTRING = 'rubocop:disable'.freeze

    ABC_SIZE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | This method seems to be too complex, try to split it into smaller ones. You can use merging for complex hash building.
    MESSAGE

    METHOD_LENGTH = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It seems like this method contains too much logic. Please, split it up into several methods, sometimes even separate classes can be a good idea.
    MESSAGE

    CLASS_LENGTH = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | This class became too big. Please, try to extract a functionality into a smaller classes. If it's a model, try to extract method into classes.
    MESSAGE

    COP_PATTERN = %r{
      (?<copname>       # Named group
        [A-Za-z]+       # Module
        \/              # Separator
        [A-Za-z]+       # Class
      )[ \n]*           # Newline or space
    }x.freeze # ex: Metrics/ParameterLists

    SUGGESTIONS = {
      'Metrics/AbcSize' => ABC_SIZE,
      'Metrics/ClassLength' => CLASS_LENGTH,
      'Metrics/MethodLength' => METHOD_LENGTH
    }.freeze

    def investigate(processed_source)
      return unless processed_source.ast

      processed_source.comments.each do |comment_node|
        next unless disabling?(comment_node)

        add_offense(comment_node, :expression,
                    [OFFENSE, *additional_comments(comment_node)].join("\n"))
      end
    end

    private

    def disabling?(node)
      node.loc.expression.source.include?(MAGIC_SUBSTRING)
    end

    def additional_comments(node)
      node.loc.expression
          .source
          .scan(COP_PATTERN)
          .flatten
          .map { |name| SUGGESTIONS[name] }
          .compact
    end
  end
end
