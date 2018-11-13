# frozen_string_literal: true

module PatchedRubocop
  module GitTurgetFinder
    def find_files(base_dir, flags)
      replacement = GitAccess.instance.changed_files
      return replacement unless replacement.empty?

      super
    end
  end
end
