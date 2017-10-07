# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options = %w[--auto-correct]
end

task :documentation do
  require './lib/ducalis/documentation'
  File.write('DOCUMENTATION.md', Documentation.new.call)
end

RSpec::Core::RakeTask.new(:spec)
task default: %i[rubocop spec]
