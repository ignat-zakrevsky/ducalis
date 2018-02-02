# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class EvlisOverusing < RuboCop::Cop::Cop
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Seems like you are overusing safe navigation operator. Try to use right method (ex: `dig` for hashes), null object pattern or ensure types via explicit conversion (`to_a`, `to_s` and so on).
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Related article: https://karolgalanciak.com/blog/2017/09/24/do-or-do-not-there-is-no-try-object-number-try-considered-harmful/
    MESSAGE

    def on_send(node)
      return unless nested_try?(node)
      add_offense(node, :expression, OFFENSE)
    end

    def on_csend(node)
      return unless node.child_nodes.any?(&:csend_type?)
      add_offense(node, :expression, OFFENSE)
    end

    def_node_search :nested_try?,
                    '(send (send _ {:try :try!} ...) {:try :try!} ...)'
  end
end
