# frozen_string_literal: true

require 'parser/current'

# This class could be used to dynamically generate documentation from cops spec.
# It recognizes bad and good examples by signal words like `raises`. Additional
# information for documentation could be passed by setting `DETAILS` constant.
class SpecsProcessor < Parser::AST::Processor
  attr_reader :cases

  LINE_BEGIN_OPEN_SQUARE_BRACKET = /\A\[/  # "/[/1, 2, 3]\n"
  CLOSE_SQUARE_BRACKET_END_LINE = /\]\z/   # "[1, 2, 3/]\n/"
  LINE_BEGIN_QUOTE = /\A[\'|\"]/           # "/'/idddqd',"
  QUOTE_COMMA_END_LINE = /[\'|\"]\,?\z/    # "'iddqd/',/"

  def initialize(*)
    super
    @cases = []
    @nesting = []
  end

  def process(node)
    @nesting.push(node)
    super
    @nesting.pop
  end

  def on_send(node)
    _, name, _body = *node
    if name == :inspect_source
      source_code = remove_array_wrapping(node.to_a.last.loc.expression.source)
                    .split("\n")
                    .map { |line| remove_string_wrapping(line) }
      cases << [current_it, source_code]
    end
    super
  end

  private

  def current_it
    it_block = @nesting.reverse.find { |node| node.type == :block }
    it = it_block.to_a.first
    _, _, message_node = *it
    message_node.to_a.first
  end

  def remove_array_wrapping(source)
    source.sub(LINE_BEGIN_OPEN_SQUARE_BRACKET, '')
          .sub(CLOSE_SQUARE_BRACKET_END_LINE, '')
  end

  def remove_string_wrapping(line)
    line.strip.sub(LINE_BEGIN_QUOTE, '')
        .sub(QUOTE_COMMA_END_LINE, '')
  end
end

class Documentation
  RED_SQUARE = '![](https://placehold.it/10/f03c15/000000?text=+)'
  GREEN_SQUARE = '![](https://placehold.it/10/2cbe4e/000000?text=+)'
  SIGNAL_WORD = 'raises'
  IGNORE_WORDS = ['[bugfix]'].freeze

  def call
    Dir['./lib/ducalis/cops/*.rb'].sort.map do |f|
      present_cop(klass_const_for(f), spec_cases_for(f))
    end.flatten.join("\n")
  end

  private

  def present_cop(klass, specs)
    [
      "## #{klass}\n",                                  # header
      message(klass)                                    # description
    ] +
      specs.map do |(it, code)|
        [
          "\n#{color(it)} #{it}",                       # case description
          "```ruby\n#{code.join("\n")}\n```"            # code example
        ]
      end
  end

  def color(it)
    it.include?(SIGNAL_WORD) ? RED_SQUARE : GREEN_SQUARE
  end

  def message(klass)
    [
      klass.const_get(:OFFENSE),
      *(klass.const_get(:DETAILS) if klass.const_defined?(:DETAILS))
    ].join("\n")
  end

  def spec_cases_for(f)
    source_code = File.read(
      f.sub('/lib/', '/spec/')
       .sub(/.rb$/, '_spec.rb')
    )
    SpecsProcessor.new.tap do |processor|
      processor.process(Parser::CurrentRuby.parse(source_code))
    end.cases.reject(&method(:ignored?))
  end

  def ignored?(example)
    desc, _code = example
    IGNORE_WORDS.any? { |word| desc.include?(word) }
  end

  def klass_const_for(f)
    require f
    Ducalis.const_get(camelize(File.basename(f).sub(/.rb$/, '')))
  end

  def camelize(snake_case_word)
    snake_case_word.sub(/^[a-z\d]*/, &:capitalize).tap do |string|
      string.gsub!(%r{(?:_|(/))([a-z\d]*)}i) do
        "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}"
      end
      string.gsub!('/', '::')
    end
  end
end
