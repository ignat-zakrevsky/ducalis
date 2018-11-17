# frozen_string_literal: true

module ComplexCases
  class SmartDeleteCheck
    WHITE_LIST = %w[File cache file params attrs options].freeze

    def self.call(who, what, args)
      !new(who, what, args).false_positive?
    end

    def initialize(who, _what, args)
      @who = who
      @args = args
    end

    def false_positive?
      [
        called_with_stringlike?,
        many_args?,
        whitelisted?
      ].any?
    end

    private

    def called_with_stringlike?
      %i[sym str].include?(@args.first && @args.first.type)
    end

    def many_args?
      @args.count > 1
    end

    def whitelisted?
      WHITE_LIST.any? { |regex| @who.to_s.include?(regex) }
    end
  end
end
