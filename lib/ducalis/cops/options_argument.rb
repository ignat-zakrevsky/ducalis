# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class OptionsArgument < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Default options argument isn't good idea. It's better to explicitly pass which keys are you interested in as keyword arguments. You can use split operator to support hash arguments.

      | Compare:

      | ```ruby
      | def generate_1(document, options = {})
      |   format = options.delete(:format)
      |   limit = options.delete(:limit) || 20
      |   # ...
      |   [format, limit, options]
      | end
      | generate_1(1, format: 'csv', limit: 5, useless_arg: :value)

      | # vs

      | def generate_2(document, format:, limit: 20, **options)
      |   # ...
      |   [format, limit, options]
      | end
      | generate_2(1, format: 'csv', limit: 5, useless_arg: :value)
      | ```
    MESSAGE

    def on_def(node)
      _name, args, _body = *node
      return unless default_options?(args)
      add_offense(node, :expression, OFFENSE)
    end

    private

    def_node_search :options_arg?, '(arg :options)'
    def_node_search :options_arg_with_default?, '(optarg :options ...)'

    def default_options?(args)
      args.children.any? do |node|
        options_arg?(node) || options_arg_with_default?(node)
      end
    end
  end
end
