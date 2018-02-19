# frozen_string_literal: true

require 'git'
require 'singleton'

module PatchedRubocop
  class GitFilesAccess
    DELETED = 'deleted'.freeze

    include PatchedRubocop::Diffs
    include Singleton

    attr_accessor :flag

    def initialize
      @dir = Dir.pwd
      @git = Git.open(@dir)
    end

    def changes
      @changes ||= MODES.fetch(@flag)
                        .call(@git)
                        .map { |diff| GitDiff.new(full_path(diff.path), diff) }
                        .reject { |diff| diff.diff.type == DELETED }
    end

    def changed?(path, line)
      find(path).changed?(line)
    end

    private

    def full_path(path)
      [@dir, path].join('/')
    end

    def find(path)
      return NilDiff.new(full_path(path), nil) if changes.empty?
      changes.find { |x| x.full_path == path }
    end
  end
end
