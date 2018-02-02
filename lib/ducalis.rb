# frozen_string_literal: true

require 'parser/current'
require 'policial'

module Ducalis
  DOTFILE = '.ducalis.yml'
  DUCALIS_HOME = File.realpath(File.join(File.dirname(__FILE__), '..'))
  DEFAULT_FILE = File.join(DUCALIS_HOME, 'config', DOTFILE)
end

require 'ducalis/version'

require 'ducalis/adapters/base'
require 'ducalis/adapters/circle_ci'
require 'ducalis/adapters/custom'
require 'ducalis/adapters/pull_request'

require 'ducalis/commentators/console'
require 'ducalis/commentators/github'

require 'ducalis/cli'
require 'ducalis/passed_args'
require 'ducalis/runner'
require 'ducalis/utils'

require 'ducalis/patched_rubocop/diffs'
require 'ducalis/patched_rubocop/ducalis_config_loader'
require 'ducalis/patched_rubocop/git_files_access'
require 'ducalis/patched_rubocop/git_runner'
require 'ducalis/patched_rubocop/git_turget_finder'
require 'ducalis/patched_rubocop/rubo_cop'

require 'ducalis/cops/extensions/type_resolving'
require 'ducalis/cops/black_list_suffix'
require 'ducalis/cops/callbacks_activerecord'
require 'ducalis/cops/case_mapping'
require 'ducalis/cops/controllers_except'
require 'ducalis/cops/data_access_objects'
require 'ducalis/cops/fetch_expression'
require 'ducalis/cops/only_defs'
require 'ducalis/cops/keyword_defaults'
require 'ducalis/cops/module_like_class'
require 'ducalis/cops/multiple_times'
require 'ducalis/cops/evlis_overusing'
require 'ducalis/cops/enforce_namespace'
require 'ducalis/cops/options_argument'
require 'ducalis/cops/params_passing'
require 'ducalis/cops/possible_tap'
require 'ducalis/cops/preferable_methods'
require 'ducalis/cops/private_instance_assign'
require 'ducalis/cops/protected_scope_cop'
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
