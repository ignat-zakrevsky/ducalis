# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class PublicSend < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | You should avoid of using `send`-like method in production code. You can rewrite it as a hash with lambdas and fetch necessary actions or rewrite it as a module which you can include in code.
    MESSAGE

    def on_send(node)
      return unless send_call?(node)
      add_offense(node, :expression, OFFENSE)
    end

    def_node_matcher :send_call?, '(send _ ${:send :public_send :__send__} ...)'
  end
end
