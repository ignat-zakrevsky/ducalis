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

    PARAMS_CALL = s(:send, nil, :params)

    def on_def(body)
      multiple = [
        date_today(body),
        date_current(body),
        time_current(body),
        time_now(body)
      ].map(&:to_a).compact.flatten.to_a
      return if multiple.count < 2
      multiple.each do |time_node|
        add_offense(time_node, :expression, OFFENSE)
      end
    end
    alias on_defs on_def
    alias on_send on_def

    def_node_search :date_today, '(send (const _ :Date) :today)'
    def_node_search :date_current, '(send (const _ :Date) :current)'
    def_node_search :time_current, '(send (const _ :Time) :current)'
    def_node_search :time_now, '(send (const _ :Time) :now)'
  end
end
