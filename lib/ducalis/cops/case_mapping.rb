# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class CaseMapping < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Try to avoid `case when` statements. You can replace it with a sequence of `if... elsif... elsif... else`.
      | For cases where you need to choose from a large number of possibilities, you can create a dictionary mapping case values to functions to call by `call`. It's nice to have prefix for the method names, i.e.: `visit_`.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Usually `case when` statements are using for the next reasons:

      | I. Mapping between different values.
      | `("A" => 1, "B" => 2, ...)`

      | This case is all about data representing. If you do not need to execute any code it's better to use data structure which represents it. This way you are separating concepts: code returns corresponding value and you have config-like data structure which describes your data.

      | ```ruby
      |   %w[A B ...].index("A") + 1
      |   # or
      |   { "A" => 1, "B" => 2 }.fetch("A")
      | ```

      | II. Code execution depending of parameter or type:

      |   - a. `(:attack => attack, :defend => defend)`
      |   - b. `(Feet => value * 0.348, Meters => `value`)`

      | In this case code violates OOP and S[O]LID principle. Code shouldn't know about object type and classes should be open for extension, but closed for modification (but you can't do it with case-statements). This is a signal that you have some problems with architecture.

      |  a.

      | ```ruby
      | attack: -> { execute_attack }, defend: -> { execute_defend }
      | #{(action = '#{' + 'action' + '}') && '# or'}
      | call(:"execute_#{action}")
      | ```

      | b.

      | ```ruby
      | class Meters; def to_metters; value;         end
      | class Feet;   def to_metters; value * 0.348; end
      | ```

      | III. Code execution depending on some statement.

      | ```ruby
      | (`a > 0` => 1, `a == 0` => 0, `a < 0` => -1)
      | ```

      | This case is combination of I and II -- high code complexity and unit-tests complexity. There are variants how to solve it:

      |  a. Rewrite to simple if statement

      | ```ruby
      | return 0 if a == 0
      | a > 0 ? 1 : -1
      | ```

      |  b. Move statements to lambdas:

      | ```ruby
      |  ->(a) { a > 0 }  =>  1,
      |  ->(a) { a == 0 } =>  0,
      |  ->(a) { a < 0 }  => -1
      | ```

      | This way decreases code complexity by delegating it to lambdas and makes it easy to unit-testing because it's easy to test pure lambdas.

      | Such approach is named [table-driven design](<https://www.d.umn.edu/~gshute/softeng/table-driven.html>). Table-driven methods are schemes that allow you to look up information in a table rather than using logic statements (i.e. case, if). In simple cases, it's quicker and easier to use logic statements, but as the logic chain becomes more complex, table-driven code is simpler than complicated logic, easier to modify and more efficient.
    MESSAGE

    def on_case(node)
      add_offense(node, :expression, OFFENSE)
    end
  end
end
