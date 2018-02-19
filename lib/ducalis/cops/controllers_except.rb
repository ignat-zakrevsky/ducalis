# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class ControllersExcept < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Prefer to use `:only` over `:except` in controllers because it's more explicit and will be easier to maintain for new developers.
    MESSAGE

    FILTERS = %i[before_filter after_filter around_filter
                 before_action after_action around_action].freeze

    def on_send(node)
      _, method_name, *args = *node
      hash_node = args.find { |subnode| subnode.type == :hash }
      return unless FILTERS.include?(method_name) && hash_node
      type, _method_names = decomposite_hash(hash_node)
      return unless type == s(:sym, :except)
      add_offense(node, :selector, OFFENSE)
    end

    private

    def decomposite_hash(args)
      args.to_a.first.children.to_a
    end
  end
end
