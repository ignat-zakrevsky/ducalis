# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class TooLongWorkers < RuboCop::Cop::Cop
    include RuboCop::Cop::ClassishLength

    OFFENSE = <<-MESSAGE.gsub(/^ +\|/, '').strip
      | Seems like your worker is doing too much work, consider of moving business
      | logic to service object. As rule, workers should have only two responsibilities:
      | - __Model materialization__: As async jobs working with serialized attributes
      | it's nescessary to cast them into actual objects.
      | - __Errors handling__: Rescue errors and figure out what to do with them.
    MESSAGE

    WORKERS_SUFFIXES = %w(Worker Job).freeze

    def on_class(node)
      return unless worker_class?(node)
      check_code_length(node)
    end

    private

    def worker_class?(node)
      classdef_node, _superclass, _body = *node
      classdef_node.source.end_with?(*WORKERS_SUFFIXES)
    end

    def message(length, max_length)
      format("#{OFFENSE} [%d/%d]", length, max_length)
    end
  end
end
