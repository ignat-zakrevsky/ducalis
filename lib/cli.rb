# frozen_string_literal: true

require 'thor'

require './lib/runner'
require './lib/adapters/base'
require './lib/adapters/circle_ci'
require './lib/adapters/custom'

module Ducalis
  class CLI < Thor
    ADAPTERS = {
      circle: Adapters::CircleCi,
      custom: Adapters::Custom
    }.freeze
    DEFAULT_ADAPTER = ADAPTERS.keys.last
    default_task :start

    desc '--ci', ''
    option :adapter, required: true, default: DEFAULT_ADAPTER,
                     desc: 'Describes how Ducalis will receive PR information'
    option :id,   type: :numeric, desc: 'PR id, ex: 2347'
    option :repo, type: :string,  desc: 'PR repository, ex: author/repo'
    option :sha,  type: :string,  desc: 'Starting commit, can be skipped'
    option :dry,  type: :boolean, default: false,
                  desc: 'Allows user run dry mode, default: false'
    def start
      adapter = ADAPTERS.fetch(options[:adapter].to_sym) do
        raise "Unsupported adapter #{options[:adapter]}"
      end
      Runner.new(adapter.new(options)).call
    end

    desc '--ci help', 'Describe available commands'
    def help(command = nil, subcommand = false)
      command ||= :start
      super
    end
  end
end
