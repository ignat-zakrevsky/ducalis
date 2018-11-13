# frozen_string_literal: true

require 'rubocop'

module Ducalis
  DOTFILE = '.ducalis.yml'.freeze
  DUCALIS_HOME = File.realpath(File.join(File.dirname(__FILE__), '..'))
  DEFAULT_FILE = File.join(DUCALIS_HOME, 'config', DOTFILE)
end

require 'ducalis/version'
require 'ducalis/errors'

require 'ducalis/adapters/circle_ci'
require 'ducalis/adapters/default'

require 'ducalis/patched_rubocop/ducalis_config_loader'
require 'ducalis/patched_rubocop/git_runner'
require 'ducalis/patched_rubocop/git_turget_finder'
require 'ducalis/patched_rubocop/inject'
require 'ducalis/patched_rubocop/cop_cast'

require 'ducalis/commentators/github'
require 'ducalis/github_formatter'

require 'ducalis/utils'
require 'ducalis/diffs'
require 'ducalis/rubo_cop'
require 'ducalis/cli_arguments'
require 'ducalis/patch'
require 'ducalis/git_access'

Dir[File.join('.', 'lib', 'ducalis', 'cops', '**', '*.rb')].each do |file|
  require file
end
