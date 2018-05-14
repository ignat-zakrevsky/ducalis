# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class DescriptiveBlockNames < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, use descriptive names as block arguments. There is no any sense to save on letters.
    MESSAGE

    def on_block(node)
      _send, args, _inner = *node
      block_arguments(args).each do |violation_node|
        add_offense(violation_node, :expression, OFFENSE)
      end
    end

    private

    def violate?(node)
      node.to_s.length < minimal_length &&
        !node.to_s.start_with?('_') &&
        !white_list.include?(node.to_s)
    end

    def white_list
      cop_config.fetch('WhiteList')
    end

    def minimal_length
      cop_config.fetch('MinimalLenght').to_i
    end

    def_node_search :block_arguments, '(arg #violate?)'
  end
end
