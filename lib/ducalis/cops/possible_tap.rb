# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class PossibleTap < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|/, '').strip
      | Consider of using `.tap`, default ruby
      | [method](<https://apidock.com/ruby/Object/tap>)
      | which allows to replace intermediate variables with block, by this you
      | are limiting scope pollution and make scope more clear.
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
      return unless body.children.last.respond_to?(:children)
      subnodes(body.children.last.to_a.first).find do |node|
        ASSIGNS.include?(node.type)
      end
    end

    def subnodes(node)
      ([node] + node.children).select { |child| child.respond_to?(:type) }
    end
  end
end
