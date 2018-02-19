# frozen_string_literal: true

require 'rubocop'
require_relative './callbacks_activerecord'

module Ducalis
  class StringsInActiverecords < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, do not use strings as arguments for %<method_name>s argument. It's hard to test, grep sources, code highlighting and so on. Consider using of symbols or lambdas for complex expressions.
    MESSAGE

    VALIDATEBLE_METHODS =
      ::Ducalis::CallbacksActiverecord::METHODS_BLACK_LIST + %i[
        validates
        validate
      ]

    def on_send(node)
      _, method_name, *args = *node
      return unless VALIDATEBLE_METHODS.include?(method_name)
      return if args.empty?
      node.to_a.last.each_child_node do |current_node|
        next if skip_node?(current_node)
        add_offense(node, :selector, format(OFFENSE, method_name: method_name))
      end
    end

    private

    def skip_node?(current_node)
      key, value = *current_node
      return true unless current_node.type == :pair
      return true unless %w[if unless].include?(key.source)
      return true unless value.type == :str
      false
    end
  end
end
