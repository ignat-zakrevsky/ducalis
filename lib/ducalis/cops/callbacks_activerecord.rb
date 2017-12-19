# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class CallbacksActiverecord < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, avoid using of callbacks for models. It's better to keep models small ("dumb") and instead use "builder" classes/services: to construct new objects.
      | You can read more [here](https://medium.com/planet-arkency/a61fd75ab2d3).
    MESSAGE

    MODELS_CLASS_NAMES = [
      'ApplicationRecord',
      'ActiveRecord::Base'
    ].freeze

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

    def on_class(node)
      _classdef_node, superclass, _body = *node
      @triggered = superclass &&
                   MODELS_CLASS_NAMES.include?(superclass.loc.expression.source)
    end

    def on_send(node)
      return unless @triggered
      return unless METHODS_BLACK_LIST.include?(node.method_name)
      add_offense(node, :selector, OFFENSE)
    end

    private

    attr_reader :triggered
  end
end
