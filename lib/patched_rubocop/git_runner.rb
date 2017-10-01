# frozen_string_literal: true

module PatchedRubocop
  module GitRunner
    def inspect_file(file)
      offenses, updated = super
      offenses = offenses.select do |offense|
        GitFilesAccess.instance.changed?(file.path, offense.line)
      end

      [offenses, updated]
    end
  end
end
