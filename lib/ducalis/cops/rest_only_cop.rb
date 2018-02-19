# frozen_string_literal: true

require 'rubocop'
require 'ducalis/cops/extensions/type_resolving'

module Ducalis
  class RestOnlyCop < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | It's better for controllers to stay adherent to REST:
      | http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | [About RESTful architecture](<https://confreaks.tv/videos/railsconf2017-in-relentless-pursuit-of-rest>)
    MESSAGE

    WHITELIST = %i[index show new edit create update destroy].freeze

    def on_def(node)
      return unless in_controller?
      return if non_public?(node)
      method_name, = *node
      return if WHITELIST.include?(method_name)
      add_offense(node, :expression, OFFENSE)
    end
    alias on_defs on_def
  end
end
