# frozen_string_literal: true

require 'policial'

class CustomRuby < Policial::Linters::Ruby
  FILES_PATTERN = /Gemfile\z|.+\.rb\z/
  KEY = :custom_ruby

  def default_config_file
    '.customcop.yml'
  end

  def custom_config
    RuboCop::ConfigLoader.load_file(default_config_file)
  end

  def filename_pattern
    FILES_PATTERN
  end
end
