# frozen_string_literal: true

module Ducalis
  class CliArguments
    ADAPTERS = [
      Adapters::CircleCI,
      Adapters::Default
    ].freeze

    HELP_FLAGS   = %w[-h -? --help].freeze
    FORMATTER    = %w[--format GithubFormatter].freeze
    DOCS_ARG     = :docs
    REPORTER_ARG = :reporter

    def docs_command?
      ARGV.any? { |arg| arg == to_key(DOCS_ARG) }
    end

    def help_command?
      ARGV.any? { |arg| HELP_FLAGS.include?(arg) }
    end

    def process!
      detect_git_mode!
      detect_reporter!
    end

    private

    def detect_reporter!
      reporter_index = ARGV.index(to_key(REPORTER_ARG)) || return
      reporter = ARGV[reporter_index + 1]
      [to_key(REPORTER_ARG), reporter].each { |arg| ARGV.delete(arg) }
      ARGV.push(*FORMATTER)
      GitAccess.instance.store_pull_request!(find_pull_request(reporter))
    end

    def detect_git_mode!
      git_mode = GitAccess::MODES.keys.find do |mode|
        ARGV.include?(to_key(mode))
      end
      return unless git_mode

      ARGV.delete(to_key(git_mode))
      GitAccess.instance.flag = git_mode
    end

    def find_pull_request(value)
      ADAPTERS.find { |adapter| adapter.suitable_for?(value) }.new(value).call
    end

    def to_key(key)
      "--#{key}"
    end
  end
end
