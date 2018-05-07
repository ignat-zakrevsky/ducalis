# frozen_string_literal: true

require 'git'
require 'singleton'

class GitAccess
  DELETED = 'deleted'.freeze
  GIT_DIR = '.git'.freeze

  MODES = {
    branch: ->(git) { git.diff('origin/master') },
    index:  ->(git) { git.diff('HEAD') }
  }.freeze

  include Diffs
  include Singleton

  attr_accessor :flag, :repo, :id

  def store_pull_request!(repo, id)
    self.repo = repo
    self.id = id
  end

  def changed_files
    changes.map(&:path)
  end

  def for(path)
    find(path)
  end

  private

  def under_git?
    @_under_git ||= Dir.exist?(File.join(Dir.pwd, GIT_DIR))
  end

  def changes
    return default_value if flag.nil? || !under_git?
    @_changes ||= patch_diffs
  end

  def patch_diffs
    MODES.fetch(flag)
         .call(Git.open(Dir.pwd))
         .reject { |diff| diff.type == DELETED }
         .select { |diff| File.exist?(diff.path) }
         .map    { |diff| GitDiff.new(diff, diff.path) }
  end

  def default_value
    raise MissingGit unless flag.nil?
    []
  end

  def find(path)
    return NilDiff.new(nil, path) if changes.empty?
    changes.find { |diff| diff.path == path }
  end
end
