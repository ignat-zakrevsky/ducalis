# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class UselessOnly < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Seems like there is no any reason to keep before filter only for one action. Maybe it will be better to inline it?
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | ```ruby
      | before_filter :do_something, only: %i[index]
      | def index; end

      | # to

      | def index
      |   do_something
      | end
      | ```
    MESSAGE

    FILTERS = %i(before_filter after_filter around_filter
                 before_action after_action around_action).freeze

    def on_send(node)
      _, method_name, *args = *node
      hash_node = args.find { |subnode| subnode.type == :hash }
      return unless FILTERS.include?(method_name) && hash_node
      type, method_names = decomposite_hash(hash_node)
      return unless type == s(:sym, :only)
      return unless method_names.children.count == 1
      add_offense(node, :selector, OFFENSE)
    end

    private

    def decomposite_hash(args)
      args.to_a.first.children.to_a
    end
  end
end
