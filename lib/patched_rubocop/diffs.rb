# frozen_string_literal: true

module PatchedRubocop
  module Diffs
    class BaseDiff
      attr_reader :full_path, :diff

      def initialize(full_path, diff)
        @full_path = full_path
        @diff = diff
      end
    end

    class NilDiff < BaseDiff
      def changed?(*)
        true
      end
    end

    class GitDiff < BaseDiff
      def changed?(changed_line)
        (Policial::Patch.new(diff.patch).changed_lines.detect do |line|
          line.number == changed_line
        end || Policial::UnchangedLine.new).changed?
      end
    end

    private_constant :BaseDiff, :NilDiff, :GitDiff
  end
end
