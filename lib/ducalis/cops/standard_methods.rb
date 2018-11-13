# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class StandardMethods < RuboCop::Cop::Cop
    BLACK_LIST = [Object].flat_map { |klass| klass.new.methods }

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, be sure that you really want to redefine standard ruby methods.
      | You should know what are you doing and all consequences.
    MESSAGE

    def on_def(node)
      name, _args, _body = *node
      return unless BLACK_LIST.include?(name)

      add_offense(node, :expression, OFFENSE)
    end
  end
end
