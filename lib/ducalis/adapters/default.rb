# frozen_string_literal: true

module Adapters
  class Default
    def self.suitable_for?(_value)
      true
    end

    def initialize(value)
      @value = value
    end

    def call
      @value.split('#')
    end
  end
end
