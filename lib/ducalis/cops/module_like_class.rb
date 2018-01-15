# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class ModuleLikeClass < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Seems like it will be better to define initialize and pass %<args>s there instead of each method.
    MESSAGE

    def on_class(node)
      _name, inheritance, body = *node
      return if !inheritance.nil? || body.nil? || allowed_include?(body)
      matched = matched_args(body)
      return if matched.empty?
      add_offense(node, :expression,
                  format(OFFENSE, args:
                      matched.map { |arg| "`#{arg}`" }.join(', ')))
    end

    private

    def allowed_include?(body)
      return if cop_config['AllowedIncludes'].to_a.empty?
      (all_includes(body) & cop_config['AllowedIncludes']).any?
    end

    def matched_args(body)
      methods_defintions = children(body).select(&public_method_definition?)
      return [] if methods_defintions.count == 1 && with_initialize?(body)
      methods_defintions.map(&method_args).inject(&:&).to_a
    end

    def children(body)
      (body.type != :begin ? s(:begin, body) : body).children
    end

    def all_includes(body)
      children(body).select(&method(:include_node?))
                    .map(&:to_a)
                    .map { |_, _, node| node.loc.expression.source }
                    .to_a
    end

    def public_method_definition?
      ->(node) { node.type == :def && !non_public?(node) && !initialize?(node) }
    end

    def method_args
      lambda do |n|
        _name, args = *n
        args.children
            .select { |node| node.type == :arg }
            .map    { |node| node.loc.expression.source }
      end
    end

    def with_initialize?(body)
      children(body).find(&method(:initialize?))
    end

    def_node_search :include_node?, '(send _ :include (...))'
    def_node_search :initialize?, '(def :initialize ...)'
  end
end
