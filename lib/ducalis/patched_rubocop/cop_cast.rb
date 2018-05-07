# frozen_string_literal: true

module PatchedRubocop
  module CopCast
    def add_offense(node, loc, message = nil, severity = nil)
      if PatchedRubocop::CURRENT_VERSION > PatchedRubocop::ADAPTED_VERSION
        super(node, location: loc, message: message, severity: severity)
      else
        super(node, loc, message, severity)
      end
    end
  end
end
