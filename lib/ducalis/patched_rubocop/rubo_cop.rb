# frozen_string_literal: true

module RuboCop
  class ConfigLoader
    ::Ducalis::Utils.silence_warnings { DOTFILE = ::Ducalis::DOTFILE }
    class << self
      prepend PatchedRubocop::DucalisConfigLoader
    end
  end

  class TargetFinder
    prepend PatchedRubocop::GitTurgetFinder
  end

  class Runner
    prepend PatchedRubocop::GitRunner
  end
end

module PatchedRubocop
  MODES = {
    branch: ->(git)  { git.diff('origin/master') },
    index:  ->(git)  { git.diff('HEAD') },
    all:    ->(_git) { [] }
  }.freeze

  module_function

  def configure!(flag)
    GitFilesAccess.instance.flag = flag
  end
end
