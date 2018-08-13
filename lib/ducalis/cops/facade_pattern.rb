# frozen_string_literal: true

require 'rubocop'
require 'ducalis/cops/extensions/type_resolving'

module Ducalis
  class FacadePattern < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | There are too many instance variables for one controller action. It's beetter to refactor it with Facade pattern to simplify the controller.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Good article about [Facade](<https://medium.com/kkempin/facade-design-pattern-in-ruby-on-rails-710aa88326f>).
    MESSAGE

    def on_def(node)
      return unless in_controller?
      return if non_public?(node)
      assigns = instance_variables_matches(node)
      return if assigns.count < max_instance_variables
      assigns.each { |assign| add_offense(assign, :expression, OFFENSE) }
    end

    private

    def max_instance_variables
      cop_config.fetch('MaxInstanceVariables')
    end

    def_node_search :instance_variables_matches, '(ivasgn ...)'
  end
end
