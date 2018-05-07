# frozen_string_literal: true

module Diffs
  class BaseDiff
    attr_reader :diff, :path

    def initialize(diff, path)
      @diff = diff
      @path = path
    end
  end

  class NilDiff < BaseDiff
    def changed?(*)
      true
    end

    def patch_line(*)
      -1
    end
  end

  class GitDiff < BaseDiff
    def changed?(changed_line)
      patch.line_for(changed_line).changed?
    end

    def patch_line(changed_line)
      patch.line_for(changed_line).patch_position
    end

    private

    def patch
      Ducalis::Patch.new(diff.patch)
    end
  end

  private_constant :BaseDiff, :NilDiff, :GitDiff
end
