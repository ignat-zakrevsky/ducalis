# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class OptionsArgument < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Default `options` (or `args`) argument isn't good idea. It's better to explicitly pass which keys are you interested in as keyword arguments. You can use split operator to support hash arguments.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Compare:

      | ```ruby
      | def generate_1(document, options = {})
      |   format = options.delete(:format)
      |   limit = options.delete(:limit) || 20
      |   # ...
      |   [format, limit, options]
      | end

      | options = { format: 'csv', limit: 5, useless_arg: :value }
      | generate_1(1, options) #=> ["csv", 5, {:useless_arg=>:value}]
      | generate_1(1, format: 'csv', limit: 5, useless_arg: :value) #=> ["csv", 5, {:useless_arg=>:value}]

      | # vs

      | def generate_2(document, format:, limit: 20, **options)
      |   # ...
      |   [format, limit, options]
      | end

      | options = { format: 'csv', limit: 5, useless_arg: :value }
      | generate_2(1, **options) #=> ["csv", 5, {:useless_arg=>:value}]
      | generate_2(1, format: 'csv', limit: 5, useless_arg: :value) #=> ["csv", 5, {:useless_arg=>:value}]
      | ```

    MESSAGE

    def on_def(node)
      return unless options_like_arg?(node)
      add_offense(node, :expression, OFFENSE)
    end

    def_node_search :options_like_arg?, '(${arg optarg}  ${:options :args} ...)'
  end
end
