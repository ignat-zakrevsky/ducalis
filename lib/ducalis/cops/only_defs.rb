# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class OnlyDefs < RuboCop::Cop::Cop
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
      return unless !instance_methods_definitions?(body) &&
                    class_methods_defintions?(body)

      add_offense(node, :expression, OFFENSE)
    end

    private

    def instance_methods_definitions?(body)
      children(body).any?(&public_method_definition?)
    end

    def class_methods_defintions?(body)
      children(body).any?(&class_method_definition?) ||
        children(body).any?(&method(:self_class_defs?))
    end

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
    def_node_search :self_class_defs?, '  (sclass (self) (begin ...))'
  end
end
