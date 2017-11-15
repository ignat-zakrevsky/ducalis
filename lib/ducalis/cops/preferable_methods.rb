# frozen_string_literal: true
require 'rubocop'

module Ducalis
  class PreferableMethods < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|/, '').strip
      | Prefer to use %<alternative>s method instead of %<original>s because of
      | %<reason>s.
    MESSAGE

    ALWAYS_TRUE = ->(_who, _what, _args) { true }

    DELETE_CHECK = lambda do |who, _what, args|
      !%i(sym str).include?(args.first && args.first.type) &&
        args.count <= 1 && who.to_s !~ /file/
    end

    DESCRIPTION = {
      # Method => [Alternative, Reason, Callable condition]
      delete_all: [:destroy_all, 'it is not invoking callbacks', ALWAYS_TRUE],
      delete: [:destroy, 'it is not invoking callbacks', DELETE_CHECK]
    }.freeze

    DETAILS = "Dangerous methods are:
#{DESCRIPTION.keys.map { |name| "`#{name}`" }.join(', ')}."

    def on_send(node)
      who, what, *args = *node
      return unless DESCRIPTION.keys.include?(what)
      alternative, reason, condition = DESCRIPTION.fetch(what)
      return unless condition.call(who, what, args)
      add_offense(node, :expression, format(OFFENSE, original: what,
                                                     alternative: alternative,
                                                     reason: reason))
    end
  end
end
