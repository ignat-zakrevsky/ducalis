# frozen_string_literal: true

require 'thor'

require './lib/runner'
require './lib/adapters/base'
require './lib/adapters/circle_ci'
require './lib/adapters/custom'

class CLI < Thor
  ADAPTERS = {
    'circle' => Adapters::CircleCi,
    'custom' => Adapters::Custom
  }.freeze
  DEFAULT_ADAPTER = ADAPTERS.keys.last
  default_task :start

  desc 'start ADAPTER', 'Run PR review with passed params'
  option :adapter, required: true, default: DEFAULT_ADAPTER
  option :sha
  option :id, type: :numeric
  option :repo
  option :dry, type: :boolean, default: false

  def start
    adapter = ADAPTERS.fetch(options[:adapter]) { raise 'Unsupported adapter' }
    Runner.new(adapter.new(options)).call
  end
end
