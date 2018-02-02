## Ducalis::BlackListSuffix

Please, avoid using of class suffixes like `Meneger`, `Client` and so on. If it has no parts, change the name of the class to what each object is managing.

It's ok to use Manager as subclass of Person, which is there to refine a type of personal that has management behavior to it.
Related [article](<http://www.carlopescio.com/2011/04/your-coding-conventions-are-hurting-you.html>)
raises on classes with suffixes from black list
```ruby
# bad
class ListSorter
end
```
## Ducalis::CallbacksActiverecord

Please, avoid using of callbacks for models. It's better to keep models small ("dumb") and instead use "builder" classes/services: to construct new objects.
You can read more [here](https://medium.com/planet-arkency/a61fd75ab2d3).
raises on ActiveRecord classes which contains callbacks
```ruby
# bad
class Product < ActiveRecord::Base
  before_create :generate_code
end
```
## Ducalis::CaseMapping

Try to avoid `case when` statements. You can replace it with a sequence of `if... elsif... elsif... else`.
For cases where you need to choose from a large number of possibilities, you can create a dictionary mapping case values to functions to call by `call`. It's nice to have prefix for the method names, i.e.: `visit_`.
Usually `case when` statements are using for the next reasons:

I. Mapping between different values.
("A" => 1, "B" => 2, ...)

This case is all about data representing. If you do not need to execute any code it's better to use data structure which represents it. This way you are separating concepts: code returns corresponding value and you have config-like data structure which describes your data.

```ruby
  %w[A B ...].index("A") + 1
  # or
  { "A" => 1, "B" => 2 }.fetch("A")
```

II. Code execution depending of parameter or type:

  - a. (:attack => attack, :defend => defend)
  - b. (Feet => value * 0.348, Meters => `value`)

In this case code violates OOP and S[O]LID principle. Code shouldn't know about object type and classes should be open for extension, but closed for modification (but you can't do it with case-statements). This is a signal that you have some problems with architecture.

 a.
```ruby
attack: -> { execute_attack }, defend: -> { execute_defend }
# or
call(:"execute_#{action}")
```

b.
```ruby
class Meters; def to_metters; value;         end
class Feet;   def to_metters; value * 0.348; end
```

III. Code execution depending on some statement.
(`a > 0` => 1, `a == 0` => 0, `a < 0` => -1)

This case is combination of I and II -- high code complexity and unit-tests complexity. There are variants how to solve it:

 a. Rewrite to simple if statement

```ruby
return 0 if a == 0
a > 0 ? 1 : -1
```

 b. Move statements to lambdas:

```ruby
 ->(a) { a > 0 }  =>  1,
 ->(a) { a == 0 } =>  0,
 ->(a) { a < 0 }  => -1
```

This way decreases code complexity by delegating it to lambdas and makes it easy to unit-testing because it's easy to test pure lambdas.

Such approach is named [table-driven design](<https://www.d.umn.edu/~gshute/softeng/table-driven.html>). Table-driven methods are schemes that allow you to look up information in a table rather than using logic statements (i.e. case, if). In simple cases, it's quicker and easier to use logic statements, but as the logic chain becomes more complex, table-driven code is simpler than complicated logic, easier to modify and more efficient.
## Ducalis::ControllersExcept

Prefer to use `:only` over `:except` in controllers because it's more explicit and will be easier to maintain for new developers.
raises for `before_filters` with `except` method as array
```ruby
# bad
class ProductsController < ApplicationController
  before_filter :update_cost, except: [:index]

  def index; end
  def edit; end

  private

  def update_cost; end
end
```
## Ducalis::DataAccessObjects

It's a good practice to move code related to serialization/deserialization out of the controller. Consider of creating Data Access Object to separate the data access parts from the application logic. It will eliminate problems related to refactoring and testing.
raises on working with `session` object
```ruby
# bad
class ProductsController < ApplicationController
  def edit
    session[:start_time] = Time.now
  end

  def update
    @time = Date.parse(session[:start_time]) - Time.now
  end
end
```
## Ducalis::EnforceNamespace

Too improve code organization it is better to define namespaces to group services by high-level features, domains or any other dimension.
raises on classes without namespace
```ruby
# bad
class MyService; end
```
raises on modules without namespace
```ruby
# bad
module MyServiceModule; end
```
## Ducalis::FetchExpression

You can use `fetch` instead:

```ruby
%<source>s
```
raises on using [] with default
```ruby
# bad
params[:to] || destination
```
raises on using ternary operator with default
```ruby
# bad
params[:to] ? params[:to] : destination
```
## Ducalis::KeywordDefaults

Prefer to use keyword arguments for defaults. It increases readability and reduces ambiguities.
raises if method definition contains default values
```ruby
# bad
def calculate(step, index, dry = true); end
```
## Ducalis::ModuleLikeClass

Seems like it will be better to define initialize and pass %<args>s there instead of each method.
raises for class without constructor but accepts the same args
```ruby
# bad
class TaskJournal
  def initialize(customer)
    # ...
  end

  def approve(task, estimate, options)
    # ...
  end

  def decline(user, task, estimate, details)
    # ...
  end

  private

  def log(record)
    # ...
  end
end
```
raises for class with only one public method with args
```ruby
# bad
class TaskJournal
  def approve(task)
    # ...
  end

  private

  def log(record)
    # ...
  end
end
```
## Ducalis::MultipleTimes

You should avoid multiple time-related calls to prevent bugs during the period junctions (like Time.now.day called twice in the same scope could return different values if you called it near 23:59:59). You can pass it as default keyword argument or assign to a local variable.
Compare:

```ruby
def period
  Date.today..(Date.today + 1.day)
end
# vs
def period(today: Date.today)
  today..(today + 1.day)
end
```
raises if method contains more then one Time.current calling
```ruby
# bad
def initialize(plan)
  @year = plan[:year] || Date.current.year
  @quarter = plan[:quarter] || quarter(Date.current)
end
```
## Ducalis::OnlyDefs

Prefer object instances to class methods because class methods resist refactoring. Begin with an object instance, even if it doesn’t have state or multiple methods right away. If you come back to change it later, you will be more likely to refactor. If it never changes, the difference between the class method approach and the instance is negligible, and you certainly won’t be any worse off.
Related article: https://codeclimate.com/blog/why-ruby-class-methods-resist-refactoring/
raises error for class with ONLY class methods
```ruby
# bad
class TaskJournal

  def self.call(task)
    # ...
  end

  def self.find(args)
    # ...
  end
end
```
## Ducalis::OptionsArgument

Default `options` (or `args`) argument isn't good idea. It's better to explicitly pass which keys are you interested in as keyword arguments. You can use split operator to support hash arguments.
Compare:

```ruby
def generate_1(document, options = {})
  format = options.delete(:format)
  limit = options.delete(:limit) || 20
  # ...
  [format, limit, options]
end

options = { format: 'csv', limit: 5, useless_arg: :value }
generate_1(1, options) #=> ["csv", 5, {:useless_arg=>:value}]
generate_1(1, format: 'csv', limit: 5, useless_arg: :value) #=> ["csv", 5, {:useless_arg=>:value}]

# vs

def generate_2(document, format:, limit: 20, **options)
  # ...
  [format, limit, options]
end

options = { format: 'csv', limit: 5, useless_arg: :value }
generate_2(1, **options) #=> ["csv", 5, {:useless_arg=>:value}]
generate_2(1, format: 'csv', limit: 5, useless_arg: :value) #=> ["csv", 5, {:useless_arg=>:value}]

```
raises if method accepts default options argument
```ruby
# bad
def generate(document, options = {})
  format = options.delete(:format)
  limit = options.delete(:limit) || 20
  [format, limit, options]
end
```
raises if method accepts options argument
```ruby
# bad
def log(record, options)
  # ...
end
```
## Ducalis::ParamsPassing

It's better to pass already preprocessed params hash to services. Or you can use `arcane` gem.
raises if user pass `params` as argument from controller
```ruby
# bad
class ProductsController < ApplicationController
  def index
    Record.new(params).log
  end
end
```
## Ducalis::PossibleTap

Consider of using `.tap`, default ruby [method](<https://apidock.com/ruby/Object/tap>) which allows to replace intermediate variables with block, by this you are limiting scope pollution and make method scope more clear.
If it isn't possible, consider of moving it to method or even inline it.
[Related article](<http://seejohncode.com/2012/01/02/ruby-tap-that/>).
raises for methods with scope variable return
```ruby
# bad
def load_group
  group = channel.groups.find(params[:group_id])
  authorize group, :edit?
  group
end
```
## Ducalis::PreferableMethods

Prefer to use %<alternative>s method instead of %<original>s because of %<reason>s.
Dangerous methods are:
`toggle!`, `save`, `delete`, `delete_all`, `update_attribute`, `update_column`, `update_columns`.
raises for `delete` method calling
```ruby
# bad
User.where(id: 7).delete
```
raises `save` method calling with validate: false
```ruby
# bad
User.where(id: 7).save(validate: false)
```
raises `update_column` method calling
```ruby
# bad
User.where(id: 7).update_column(admin: false)
```
## Ducalis::PrivateInstanceAssign

Don't use controller's filter methods for setting instance variables, use them only for changing application flow, such as redirecting if a user is not authenticated. Controller instance variables are forming contract between controller and view. Keeping instance variables defined in one place makes it easier to: reason, refactor and remove old views, test controllers and views, extract actions to new controllers, etc.
If you want to memoize variable, please, add underscore to the variable name start: `@_name`.
raises for instance variables in controllers private methods
```ruby
# bad
class EmployeesController < ApplicationController
  private

  def load_employee
    @employee = Employee.find(params[:id])
  end
end
```
raises for memoization variables in controllers private methods
```ruby
# bad
class EmployeesController < ApplicationController
  private

  def catalog
    @catalog ||= Catalog.new
  end
end
```
ignores memoization variables in private methods with _
```ruby
# good
class EmployeesController < ApplicationController
  private

  def catalog
    @_catalog ||= Catalog.new
  end
end
```
## Ducalis::ProtectedScopeCop

Seems like you are using `find` on non-protected scope. Potentially it could lead to unauthorized access. It's better to call `find` on authorized resources scopes.
Example:

```ruby
current_group.employees.find(params[:id])
# better then
Employee.find(params[:id])
```
raises if somewhere AR search was called on not protected scope
```ruby
# bad
Group.find(8)
```
## Ducalis::RaiseWithoutErrorClass

It's better to add exception class as raise argument. It will make easier to catch and process it later.
raises when `raise` called without exception class
```ruby
# bad
raise "Something went wrong"
```
## Ducalis::RegexCop

It's better to move regex to constants with example instead of direct using it. It will allow you to reuse this regex and provide instructions for others.

Example:

```ruby
CONST_NAME = %<constant>s # "%<example>s"
%<fixed_string>s
```
Available regexes are:
      `/[[:alnum:]]/`, `/[[:alpha:]]/`, `/[[:blank:]]/`, `/[[:cntrl:]]/`, `/[[:digit:]]/`, `/[[:graph:]]/`, `/[[:lower:]]/`, `/[[:print:]]/`, `/[[:punct:]]/`, `/[[:space:]]/`, `/[[:upper:]]/`, `/[[:xdigit:]]/`, `/[[:word:]]/`, `/[[:ascii:]]/`
raises if somewhere used regex which is not moved to const
```ruby
# bad
name = "john"
puts "hi" if name =~ /john/
```
## Ducalis::RestOnlyCop

It's better for controllers to stay adherent to REST:
http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/.
[About RESTful architecture](<https://confreaks.tv/videos/railsconf2017-in-relentless-pursuit-of-rest>)
raises for controllers with non-REST methods
```ruby
# bad
class ProductsController < ApplicationController
  def index; end
  def recalculate; end
end
```
## Ducalis::RubocopDisable

Please, do not suppress RuboCop metrics, may be you can introduce some refactoring or another concept.
raises on RuboCop disable comments
```ruby
# bad
# rubocop:disable Metrics/ParameterLists
def calculate(five, args, at, one, list); end
```
## Ducalis::StandardMethods

Please, be sure that you really want to redefine standard ruby methods.
You should know what are you doing and all consequences.
raises if use redefines default ruby methods
```ruby
# bad
def to_s
  "my version"
end
```
## Ducalis::StringsInActiverecords

Please, do not use strings as arguments for %<method_name>s argument. It's hard to test, grep sources, code highlighting and so on. Consider using of symbols or lambdas for complex expressions.
raises for string if argument
```ruby
# bad
before_save :set_full_name, 
 if: 'name_changed? || postfix_name_changed?'
```
## Ducalis::TooLongWorkers

Seems like your worker is doing too much work, consider of moving business logic to service object. As rule, workers should have only two responsibilities:
- __Model materialization__: As async jobs working with serialized attributes it's nescessary to cast them into actual objects.
- __Errors handling__: Rescue errors and figure out what to do with them.
raises for a class with more than 5 lines
```ruby
# bad
class TestWorker
  a = 1
  a = 2
  a = 3
  a = 4
  a = 5
  a = 6
end
```
## Ducalis::UncommentedGem

Please, add comment why are you including non-realized gem version for %<gem>s.
It will increase [bus-factor](<https://en.wikipedia.org/wiki/Bus_factor>).
raises for gem from github without comment
```ruby
# bad
gem 'pry', '~> 0.10', '>= 0.10.0'
gem 'rake', '~> 12.1'
gem 'rspec', git: 'https://github.com/rspec/rspec'
```
ignores for gem from github with comment
```ruby
# good
gem 'pry', '~> 0.10', '>= 0.10.0'
gem 'rake', '~> 12.1'
gem 'rspec', github: 'rspec/rspec' # new non released API
```
## Ducalis::UnlockedGem

It's better to lock gem versions explicitly with pessimistic operator (~>).
raises for gem without version
```ruby
# bad
gem 'pry'
```
ignores gems with locked versions
```ruby
# good
gem 'pry', '~> 0.10', '>= 0.10.0'
gem 'rake', '~> 12.1'
gem 'thor', '= 0.20.0'
gem 'rspec', github: 'rspec/rspec'
```
## Ducalis::UselessOnly

Seems like there is no any reason to keep before filter only for one action. Maybe it will be better to inline it?
```ruby
before_filter :do_something, only: %i[index]
def index; end

# to

def index
  do_something
end
```
raises for `before_filters` with only one method
```ruby
# bad
class ProductsController < ApplicationController
  before_filter :update_cost, only: [:index]

  def index; end

  private

  def update_cost; end
end
```