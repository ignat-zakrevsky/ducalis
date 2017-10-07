# frozen_string_literal: true

module PatchedRubocop
  module DucalisConfigLoader
    def configuration_file_for(target_dir)
      config = super
      if config == RuboCop::ConfigLoader::DEFAULT_FILE
        ::Ducalis::DEFAULT_FILE
      else
        config
      end
    end
  end
end
