# frozen_string_literal: true

class GithubFormatter < RuboCop::Formatter::BaseFormatter
  attr_reader :all

  def started(_target_files)
    @all = []
  end

  def file_finished(_file, offenses)
    print '.'
    @all << offenses unless offenses.empty?
  end

  def finished(_inspected_files)
    print "\n"
    Ducalis::Commentators::Github.new(
      GitAccess.instance.repo,
      GitAccess.instance.id
    ).call(@all.flatten)
  end
end
