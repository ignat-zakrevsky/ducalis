# frozen_string_literal: true

require 'rubocop'
require 'ducalis/cops/extensions/type_resolving'

module Ducalis
  class PrivateInstanceAssign < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Don't use controller's filter methods for setting instance variables, use them only for changing application flow, such as redirecting if a user is not authenticated. Controller instance variables are forming contract between controller and view. Keeping instance variables defined in one place makes it easier to: reason, refactor and remove old views, test controllers and views, extract actions to new controllers, etc.
    MESSAGE

    ADD_OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      If you want to memoize variable, please, add underscore to the variable name start: `@_name`.
    MESSAGE

    DETAILS = ADD_OFFENSE

    def on_ivasgn(node)
      return unless in_controller?
      return unless non_public?(node)
      return check_memo(node) if node.parent.type == :or_asgn
      add_offense(node, :expression, OFFENSE)
    end

    private

    def check_memo(node)
      return if node.to_a.first.to_s.start_with?('@_')
      add_offense(node, :expression, [OFFENSE, ADD_OFFENSE].join(' '))
    end
  end
end
