# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class RestOnlyCop < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    OFFENSE = <<-MESSAGE.gsub(/^ +\|/, '').strip
      | It's better for controllers to stay adherent to REST:
      | http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|/, '').strip
      | [About RESTful architecture](<https://confreaks.tv/videos/railsconf2017-in-relentless-pursuit-of-rest>)
    MESSAGE

    WHITELIST = %i(index show new edit create update destroy).freeze

    def on_class(node)
      _classdef_node, superclass, _body = *node
      return if superclass.nil?
      @triggered = superclass.loc.expression.source =~ /Controller/
    end

    def on_def(node)
      return unless triggered
      return if non_public?(node)
      method_name, = *node
      return if WHITELIST.include?(method_name)
      add_offense(node, :expression, OFFENSE)
    end
    alias on_defs on_def

    private

    attr_reader :triggered
  end
end
