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

require 'ducalis/cops/black_list_suffix'
require 'ducalis/cops/callbacks_activerecord'
require 'ducalis/cops/case_mapping'
require 'ducalis/cops/controllers_except'
require 'ducalis/cops/data_access_objects'
require 'ducalis/cops/descriptive_block_names'
require 'ducalis/cops/enforce_namespace'
require 'ducalis/cops/evlis_overusing'
require 'ducalis/cops/extensions/type_resolving'
require 'ducalis/cops/fetch_expression'
require 'ducalis/cops/keyword_defaults'
require 'ducalis/cops/module_like_class'
require 'ducalis/cops/multiple_times'
require 'ducalis/cops/only_defs'
require 'ducalis/cops/options_argument'
require 'ducalis/cops/params_passing'
require 'ducalis/cops/possible_tap'
require 'ducalis/cops/preferable_methods'
require 'ducalis/cops/private_instance_assign'
require 'ducalis/cops/protected_scope_cop'
require 'ducalis/cops/public_send'
require 'ducalis/cops/raise_without_error_class'
require 'ducalis/cops/regex_cop'
require 'ducalis/cops/rest_only_cop'
require 'ducalis/cops/rubocop_disable'
require 'ducalis/cops/standard_methods'
require 'ducalis/cops/strings_in_activerecords'
require 'ducalis/cops/too_long_workers'
require 'ducalis/cops/uncommented_gem'
require 'ducalis/cops/unlocked_gem'
require 'ducalis/cops/useless_only'
