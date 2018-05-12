# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class UncommentedGem < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, add comment why are you including non-realized gem version for %<gem>s.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It will increase [bus-factor](<https://en.wikipedia.org/wiki/Bus_factor>).
    MESSAGE

    ALLOWED_KEYS = %w[require group :require :group].freeze

    def investigate(processed_source)
      return unless processed_source.ast
      gem_declarations(processed_source.ast).select do |node|
        _, _, gemname, _args = *node
        next if commented?(processed_source, node)
        add_offense(node, :selector,
                    format(OFFENSE, gem: gemname.loc.expression.source))
      end
    end

    private

    def_node_search :gem_declarations, '(send _ :gem str #allowed_args?)'

    def commented?(processed_source, node)
      processed_source.comments
                      .map { |subnode| subnode.loc.line }
                      .include?(node.loc.line)
    end

    def allowed_args?(args)
      return false if args.nil? || args.type != :hash
      args.children.any? do |arg_node|
        !ALLOWED_KEYS.include?(arg_node.children.first.source)
      end
    end
  end
end
