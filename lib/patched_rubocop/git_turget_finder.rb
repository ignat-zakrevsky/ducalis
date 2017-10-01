# frozen_string_literal: true

module PatchedRubocop
  module GitTurgetFinder
    def find_files(base_dir, flags)
      replacement = GitFilesAccess.instance.changes
      return replacement.map(&:full_path) unless replacement.empty?
      super
    end
  end
end
