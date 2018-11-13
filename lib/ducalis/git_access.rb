# frozen_string_literal: true

require 'git'
require 'singleton'

class GitAccess
  DELETED = 'deleted'.freeze
  GIT_DIR = '.git'.freeze

  MODES = {
    branch: ->(git) { git.diff('origin/master') },
    index: ->(git) { git.diff('HEAD') }
  }.freeze

  include Diffs
  include Singleton

  attr_accessor :flag, :repo, :id

  def store_pull_request!(info)
    repo, id = info
    self.repo = repo
    self.id = id
  end

  def changed_files
    changes.map(&:path)
  end

  def for(path)
    return find(path) unless path.include?(Dir.pwd)

    find(Pathname.new(path).relative_path_from(Pathname.new(Dir.pwd)).to_s)
  end

  private

  def under_git?
    @under_git ||= Dir.exist?(File.join(Dir.pwd, GIT_DIR))
  end

  def changes
    return default_value if flag.nil? || !under_git?

    @changes ||= patch_diffs
  end

  def patch_diffs
    MODES.fetch(flag)
         .call(Git.open(Dir.pwd))
         .reject { |diff| diff.type == DELETED }
         .select { |diff| File.exist?(diff.path) }
         .map    { |diff| GitDiff.new(diff, diff.path) }
  end

  def default_value
    raise Ducalis::MissingGit unless flag.nil?

    []
  end

  def find(path)
    changes.find { |diff| diff.path == path } || NilDiff.new(nil, path)
  end
end
