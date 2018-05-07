# frozen_string_literal: true

module PatchedRubocop
  CURRENT_VERSION = Gem::Version.new(RuboCop::Version.version)
  ADAPTED_VERSION = Gem::Version.new('0.46.0')
end

module RuboCop
  class ConfigLoader
    ::Ducalis::Utils.silence_warnings { DOTFILE = ::Ducalis::DOTFILE }
    class << self
      prepend PatchedRubocop::DucalisConfigLoader
    end
  end

  class CommentConfig
    ::Ducalis::Utils.silence_warnings do
      COMMENT_DIRECTIVE_REGEXP = Regexp.new(
        ('# ducalis : ((?:dis|en)able)\b ' + COPS_PATTERN).gsub(' ', '\s*')
      )
    end
  end

  class TargetFinder
    prepend PatchedRubocop::GitTurgetFinder
  end

  class Runner
    prepend PatchedRubocop::GitRunner
  end
end

RuboCop::Cop::Cop.prepend(PatchedRubocop::CopCast)
PatchedRubocop::Inject.defaults!
