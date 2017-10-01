# frozen_string_literal: true

require 'singleton'

require './lib/patched_rubocop/diffs'
require './lib/patched_rubocop/git_turget_finder'
require './lib/patched_rubocop/git_runner'

module PatchedRubocop
  class GitFilesAccess
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
