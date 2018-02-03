# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class ProtectedScopeCop < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Seems like you are using `find` on non-protected scope. Potentially it could lead to unauthorized access. It's better to call `find` on authorized resources scopes.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Example:

      | ```ruby
      | current_group.employees.find(params[:id])
      | # better then
      | Employee.find(params[:id])
      | ```

    MESSAGE

    def on_send(node)
      return unless [find_method?(node), find_by_id?(node)].any?
      return unless const_like?(node)
      add_offense(node, :expression, OFFENSE)
    end

    def_node_search :const_like?, '(const ...)'
    def_node_search :find_method?, '(send (...) :find (...))'
    def_node_search :find_by_id?,
                    '(send (...) :find_by (:hash (:pair (:sym :id) (...))))'
  end
end
