# frozen_string_literal: true

module Adapters
  class CircleCI
    CODE = 'circleci'.freeze

    def self.suitable_for?(value)
      value == CODE
    end

    def initialize(_value); end

    def call
      [repo, id]
    end

    private

    def repo
      @repo ||= ENV.fetch('CIRCLE_REPOSITORY_URL')
                   .sub('https://github.com/', '')
                   .sub('git@github.com:', '')
                   .sub('.git', '')
    end

    def id
      @id   ||= ENV.fetch('CI_PULL_REQUEST')
                   .split('/')
                   .last
    end
  end
end
