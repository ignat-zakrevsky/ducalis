# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class ParamsPassing < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It's better to pass already preprocessed params hash to services. Or you can use `arcane` gem.
    MESSAGE

    PARAMS_CALL = s(:send, nil, :params)

    def on_send(node)
      _who, _what, *args = *node
      node = inspect_args(args)
      add_offense(node, :expression, OFFENSE) if node
    end

    private

    def inspect_args(args)
      return if Array(args).empty?

      args.find { |arg| arg == PARAMS_CALL }.tap do |node|
        return node if node
      end
      inspect_hash(args.find { |arg| arg.type == :hash })
    end

    def inspect_hash(args)
      return if args.nil?

      args.children.find { |arg| arg.to_a[1] == PARAMS_CALL }
    end
  end
end
