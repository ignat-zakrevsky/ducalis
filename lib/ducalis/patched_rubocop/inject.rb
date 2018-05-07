# frozen_string_literal: true

module PatchedRubocop
  module Inject
    PATH = Ducalis::DEFAULT_FILE.to_s

    def self.defaults!
      hash = RuboCop::ConfigLoader.send(:load_yaml_configuration, PATH)
      config = RuboCop::Config.new(hash, PATH)
      puts "configuration from #{PATH}" if RuboCop::ConfigLoader.debug?
      config = RuboCop::ConfigLoader.merge_with_default(config, PATH)
      RuboCop::ConfigLoader
        .instance_variable_set(:@default_configuration, config)
    end
  end
end
