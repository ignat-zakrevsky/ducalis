# frozen_string_literal: true

module CopHelperCast
  def inspect_source(source, file = nil)
    if PatchedRubocop::CURRENT_VERSION > PatchedRubocop::SPEC_CHANGES_VERSION
      super(Array(source).join("\n"), file)
    elsif PatchedRubocop::CURRENT_VERSION > PatchedRubocop::ADAPTED_VERSION
      super(source, file)
    else
      super(cop, source, file)
    end
  end
end

CopHelper.prepend(CopHelperCast)
