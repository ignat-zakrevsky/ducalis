# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class PossibleTap < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Consider of using `.tap`, default ruby [method](<https://apidock.com/ruby/Object/tap>) which allows to replace intermediate variables with block, by this you are limiting scope pollution and make method scope more clear.
      | If it isn't possible, consider of moving it to method or even inline it.
      |
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | [Related article](<http://seejohncode.com/2012/01/02/ruby-tap-that/>).
    MESSAGE

    PAIRS = {
      lvar: :lvasgn,
      ivar: :ivasgn
    }.freeze

    ASSIGNS = PAIRS.keys

    def on_def(node)
      _name, _args, body = *node
      return if body.nil?
      return unless (possibe_var = return_var?(body) || return_var_call?(body))
      return unless (assign_node = find_assign(body, possibe_var))
      add_offense(assign_node, :expression, OFFENSE)
    end

    private

    def unwrap_asign(node)
      node.type == :or_asgn ? node.children.first : node
    end

    def find_assign(body, var_node)
      subnodes(body).find do |subnode|
        unwrap_asign(subnode).type == PAIRS[var_node.type] &&
          unwrap_asign(subnode).to_a.first == var_node.to_a.first
      end
    end

    def return_var?(body)
      return unless body.children.last.respond_to?(:type)
      return unless ASSIGNS.include?(body.children.last.type)
      body.children.last
    end

    def return_var_call?(body)
      return unless last_child(body).respond_to?(:children)
      return if last_child(body).type == :if
      subnodes(last_child(body).to_a.first).find do |node|
        ASSIGNS.include?(node.type)
      end
    end

    def subnodes(node)
      return [] unless node.respond_to?(:children)
      ([node] + node.children).select { |child| child.respond_to?(:type) }
    end

    def last_child(body)
      body.children.last
    end
  end
end
