# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class Recursion < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      It seems like you are using recursion in your code. In common, it is not a bad idea, but try to keep your business logic layer free from refursion code.
    MESSAGE

    def on_def(node)
      @method_name, _args, body = *node
      return unless body
      return unless send_call?(body) || send_self_call?(body)

      add_offense(node, :expression, OFFENSE)
    end

    private

    def call_itself?(call_name)
      @method_name == call_name
    end

    def_node_search :send_call?, '(send nil? #call_itself? ...)'
    def_node_search :send_self_call?, '(send (self) #call_itself? ...)'
  end
end
