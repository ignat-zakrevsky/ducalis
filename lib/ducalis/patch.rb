# frozen_string_literal: true

module Ducalis
  class Patch
    RANGE_LINE = /^@@ .+\+(?<line_number>\d+),/.freeze
    MODIFIED_LINE = /^\+(?!\+|\+)/.freeze
    NOT_REMOVED_LINE = /^[^-]/.freeze
    ANY_LINE = /.*/.freeze

    DIFF_LINES = {
      RANGE_LINE => lambda do |lines, _line_number, line, _position|
        [lines, line.match(RANGE_LINE)[:line_number].to_i]
      end,
      MODIFIED_LINE => lambda do |lines, line_number, line, position|
        [lines + [Line.new(line_number, line, position)], line_number + 1]
      end,
      NOT_REMOVED_LINE => lambda do |lines, line_number, _line, _position|
        [lines, line_number + 1]
      end,
      ANY_LINE => lambda do |lines, line_number, _line, _position|
        [lines, line_number]
      end
    }.freeze

    def initialize(patch)
      diff_only = patch[patch.match(RANGE_LINE).begin(0)..-1]
      @patch_lines = diff_only.lines.to_enum.with_index
    end

    def line_for(line_number)
      changed_lines.detect do |line|
        line.number == line_number
      end || UnchangedLine.new
    end

    private

    attr_reader :patch_lines

    def changed_lines
      patch_lines.inject([[], 0]) do |(lines, line_number), (line, position)|
        _regex, action = DIFF_LINES.find { |regex, _action| line =~ regex }
        action.call(lines, line_number, line, position)
      end.first
    end
  end

  class UnchangedLine
    def initialize(*); end

    def patch_position
      -1
    end

    def changed?
      false
    end
  end

  class Line
    attr_reader :number, :content, :patch_position

    def initialize(number, content, patch_position)
      @number = number
      @content = content
      @patch_position = patch_position
    end

    def changed?
      true
    end
  end
  private_constant :Line, :UnchangedLine
end
