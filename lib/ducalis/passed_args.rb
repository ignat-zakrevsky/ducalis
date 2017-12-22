# frozen_string_literal: true

module Ducalis
  module PassedArgs
    module_function

    HELP_FLAGS = ['-h', '-?', '--help'].freeze

    def help_command?
      ARGV.any? { |arg| HELP_FLAGS.include?(arg) }
    end

    def ci_mode?
      ARGV.any? { |arg| arg == '--ci' }
    end

    def process_args!
      flag = PatchedRubocop::MODES.keys
                                  .map { |key| key if ARGV.delete("--#{key}") }
                                  .find { |possible_flag| !possible_flag.nil? }
      PatchedRubocop.configure!(flag || :all)
    end
  end
end
