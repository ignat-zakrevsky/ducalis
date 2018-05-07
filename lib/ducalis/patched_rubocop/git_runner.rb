# frozen_string_literal: true

module PatchedRubocop
  module GitRunner
    def inspect_file(file)
      offenses, updated = super
      offenses = offenses.select do |offense|
        GitAccess.instance.for(file.path).changed?(offense.line)
      end

      [offenses, updated]
    end
  end
end
