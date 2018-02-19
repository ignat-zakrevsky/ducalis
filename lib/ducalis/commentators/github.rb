# frozen_string_literal: true

module Ducalis
  module Commentators
    class Github
      STATUS = 'COMMENT'.freeze
      SIMILARITY_THRESHOLD = 0.8

      def initialize(config)
        @config = config
      end

      def call(violations)
        comments = violations.map do |violation|
          next if commented?(violation)
          generate_comment(violation)
        end.compact
        return if comments.empty?
        Utils.octokit
             .create_pull_request_review(@config.repo, @config.id,
                                         event: STATUS, comments: comments)
      end

      private

      def commented?(violation)
        commented_violations.find do |commented_violation|
          [
            violation.filename == commented_violation[:path],
            violation.line.patch_position == commented_violation[:position],
            similar_messages?(violation.message, commented_violation[:body])
          ].all?
        end
      end

      def similar_messages?(message, body)
        body.include?(message) ||
          Utils.similarity(message, body) > SIMILARITY_THRESHOLD
      end

      def commented_violations
        @commented_violations ||=
          Utils.octokit.pull_request_comments(@config.repo, @config.id)
      end

      def generate_comment(violation)
        {
          body: violation.message,
          path: violation.filename,
          position: violation.line.patch_position
        }
      end
    end
  end
end
