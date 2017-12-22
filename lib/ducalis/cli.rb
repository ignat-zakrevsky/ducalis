# frozen_string_literal: true

require 'optparse'

module Ducalis
  class CLI
    ADAPTERS = {
      circle: Adapters::CircleCi,
      custom: Adapters::Custom
    }.freeze
    DEFAULT_ADAPTER = ADAPTERS.keys.last

    def initialize(arguments)
      @arguments = arguments
      @options   = {}
      @parser    = OptionParser.new
      configure_parser!
    end

    def start
      @parser.parse(@arguments)
      Runner.new(adapter.new(@options)).call
    end

    private

    def adapter
      ADAPTERS.fetch(@options.fetch(:adapter, DEFAULT_ADAPTER)) do
        raise "Unsupported adapter #{@options[:adapter]}"
      end
    end

    def configure_parser!
      @parser.banner = 'Usage: ducalis --ci --adapter=ADAPTER'
      adapter_option_parsing
      id_option_parsing
      repo_option_parsing
      sha_option_parsing
      dry_option_parsing
      help_command
    end

    def help_command
      @parser.on_tail('--help', 'Show this message') do
        puts @parser
        RuboCop::CLI.new.run(@arguments)
      end
    end

    def adapter_option_parsing
      @parser.on(
        '--adapter=ADAPTER',
        'Describes how Ducalis will receive PR information. Default: custom'
      ) do |adapter|
        @options[:adapter] = adapter.to_sym
      end
    end

    def id_option_parsing
      @parser.on(
        '--id=N',
        'PR id, ex: 2347'
      ) do |id|
        @options[:id] = id
      end
    end

    def repo_option_parsing
      @parser.on(
        '--repo=REPO',
        'PR repository, ex: author/repo'
      ) do |repo|
        @options[:repo] = repo
      end
    end

    def sha_option_parsing
      @parser.on(
        '--sha=SHA',
        'Starting commit, can be omitted'
      ) do |sha|
        @options[:sha] = sha
      end
    end

    def dry_option_parsing
      @options[:dry] = false # default
      @parser.on(
        '--dry',
        'Allows user to run dry mode, default: false'
      ) do |_dry|
        @options[:dry] = true
      end
    end
  end
end
