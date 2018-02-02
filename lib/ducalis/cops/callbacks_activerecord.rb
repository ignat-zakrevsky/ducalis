# frozen_string_literal: true

require 'rubocop'
require 'ducalis/cops/extensions/type_resolving'

module Ducalis
  class CallbacksActiverecord < RuboCop::Cop::Cop
    prepend TypeResolving

    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, avoid using of callbacks for models. It's better to keep models small ("dumb") and instead use "builder" classes/services: to construct new objects.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | You can read more [here](https://medium.com/planet-arkency/a61fd75ab2d3).
    MESSAGE

    METHODS_BLACK_LIST = %i(
      after_commit
      after_create
      after_destroy
      after_find
      after_initialize
      after_rollback
      after_save
      after_touch
      after_update
      after_validation
      around_create
      around_destroy
      around_save
      around_update
      before_create
      before_destroy
      before_save
      before_update
      before_validation
    ).freeze

    def on_send(node)
      return unless in_model?
      return unless METHODS_BLACK_LIST.include?(node.method_name)
      add_offense(node, :selector, OFFENSE)
    end
  end
end
