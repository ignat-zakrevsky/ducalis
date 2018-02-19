# frozen_string_literal: true

require 'logger'

module Ducalis
  module Commentators
    class Console
      DOCUMENTATION_PATH = 'https://ducalis-rb.github.io/'.freeze

      def initialize(config)
        @config = config
      end

      def call(violations)
        violations.each do |violation|
          logger.info(generate_message(violation))
        end
      end

      private

      def generate_message(violation)
        [
          [cyan(violation.filename), violation.line.patch_position].join(':'),
          brown(violation.linter),
          bold(ancor(violation))
        ].join(' ')
      end

      def logger
        @logger ||= Logger.new(STDOUT).tap do |logger|
          logger.formatter = proc do |_severity, _datetime, _progname, msg|
            "#{msg}\n"
          end
        end
      end

      def ancor(violation)
        [
          DOCUMENTATION_PATH,
          '#',
          violation.linter.downcase.gsub(/[^[:alpha:]]/, '')
        ].join
      end

      def bold(text)
        "\e[1m#{text}\e[22m"
      end

      def brown(text)
        "\e[33m#{text}\e[0m"
      end

      def cyan(text)
        "\e[36m#{text}\e[0m"
      end
    end
  end
end
