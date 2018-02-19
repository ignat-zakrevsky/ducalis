# frozen_string_literal: true

module RubocopCast
  OLD_RUBOCOP_VERSION = Gem::Version.new('0.46.0')

  def add_offense(node, loc, message = nil, severity = nil)
    if Gem::Version.new(RuboCop::Version.version) > OLD_RUBOCOP_VERSION
      super(node, location: loc, message: message, severity: severity)
    else
      super(node, loc, message, severity)
    end
  end
end
