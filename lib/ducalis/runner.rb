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
      # Style guides were changed to linters in `policial` upstream
      if Policial.respond_to?(:linters)
        Policial.linters = [Policial::Linters::Ruby]
      else
        Policial.style_guides = [Policial::StyleGuides::Ruby]
      end
    end

    def commentator
      @commentator ||=
        config.dry? ? Commentators::Console : Commentators::Github
    end
  end
end
