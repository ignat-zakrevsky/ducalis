# frozen_string_literal: true

module CopHelperCast
  def inspect_source(source, file = nil)
    if Gem::Version.new(RuboCop::Version.version) >
       RubocopCast::OLD_RUBOCOP_VERSION
      super(source, file)
    else
      super(cop, source, file)
    end
  end
end
