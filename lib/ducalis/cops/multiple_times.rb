# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class MultipleTimes < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | You should avoid multiple time-related calls to prevent bugs during the period junctions (like Time.now.day called twice in the same scope could return different values if you called it near 23:59:59). You can pass it as default keyword argument or assign to a local variable.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Compare:

      | ```ruby
      | def period
      |   Date.today..(Date.today + 1.day)
      | end
      | # vs
      | def period(today: Date.today)
      |   today..(today + 1.day)
      | end
      | ```

    MESSAGE

    def on_def(body)
      multiple = [date_methods(body), time_methods(body)].flat_map(&:to_a)
      return if multiple.count < 2

      multiple.each do |time_node|
        add_offense(time_node, :expression, OFFENSE)
      end
    end
    alias on_defs on_def
    alias on_send on_def

    def_node_search :date_methods,
                    '(send (const _ :Date) {:today :current :yesterday})'
    def_node_search :time_methods,
                    '(send (const _ :Time) {:current :now})'
  end
end
