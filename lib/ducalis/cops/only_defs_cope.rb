# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class OnlyDefsCope < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Prefer object instances to class methods because class methods resist refactoring. Begin with an object instance, even if it doesn’t have state or multiple methods right away. If you come back to change it later, you will be more likely to refactor. If it never changes, the difference between the class method approach and the instance is negligible, and you certainly won’t be any worse off.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Related article: https://codeclimate.com/blog/why-ruby-class-methods-resist-refactoring/
    MESSAGE

    def on_class(node)
      _name, inheritance, body = *node
      return if !inheritance.nil? || body.nil?
      instance_methods = children(body).select(&public_method_definition?)
      class_methods    = children(body).select(&class_method_definition?)

      return unless instance_methods.empty? && class_methods.any?
      add_offense(node, :expression, OFFENSE)
    end

    private

    def public_method_definition?
      lambda do |node|
        node.type == :def && !non_public?(node) && !initialize?(node)
      end
    end

    def class_method_definition?
      lambda do |node|
        node.type == :defs && !non_public?(node) && !initialize?(node)
      end
    end

    def children(body)
      (body.type != :begin ? s(:begin, body) : body).children
    end

    def_node_search :initialize?, '(def :initialize ...)'
  end
end
