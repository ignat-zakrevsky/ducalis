# frozen_string_literal: true

module Ducalis
  class MissingGit < ::StandardError
    MESSAGE = "Can't find .git folder.".freeze

    def initialize(msg = MESSAGE)
      super
    end
  end

  class MissingToken < ::StandardError
    MESSAGE = 'You should provide token in order to interact with GitHub'.freeze

    def initialize(msg = MESSAGE)
      super
    end
  end
end
