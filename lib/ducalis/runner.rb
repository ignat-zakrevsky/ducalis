# frozen_string_literal: true

module Policial
  class ConfigLoader
    def raw(filename)
      File.read(filename)
    end
  end
end

module Ducalis
  class Runner
    def initialize(config)
      @config = config
      configure
    end

    def call
      detective = Policial::Detective.new(Utils.octokit)
      detective.brief(commit_info)
      detective.investigate(ruby: { config_file: Ducalis::DEFAULT_FILE })
      commentator.new(config).call(detective.violations)
    end

    private

    attr_reader :config

    def commit_info
      { repo: config.repo, number: config.id, head_sha: config.sha }
    end

    def configure
      Octokit.auto_paginate = true
      Policial.linters = [Policial::Linters::Ruby]
    end

    def commentator
      @commentator ||=
        config.dry? ? Commentators::Console : Commentators::Github
    end
  end
end
