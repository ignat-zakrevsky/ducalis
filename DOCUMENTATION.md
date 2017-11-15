## Ducalis::BlackListSuffix

Please, avoid using of class suffixes like `Meneger`, `Client`
 and so on. If it has no parts, change the name of the class to what
 each object is managing. It's ok to use Manager as subclass of Person,
 which is there to refine a type of personal that has management
 behavior to it.
 Related [article](<http://www.carlopescio.com/2011/04/your-coding-conventions-are-hurting-you.html>)

![](https://placehold.it/10/f03c15/000000?text=+) raises on classes with suffixes from black list
```ruby

class ListSorter
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores classes with okish suffixes
```ruby

class SortedList
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores classes with full match
```ruby

class Manager
end

```
## Ducalis::CallbacksActiverecord

Please, avoid using of callbacks for models. It's better to
 keep models small ("dumb") and instead use "builder" classes
 / services: to construct new objects. You can read more
 [here](https://medium.com/planet-arkency/a61fd75ab2d3).

![](https://placehold.it/10/f03c15/000000?text=+) raises on ActiveRecord classes which contains callbacks
```ruby

class Product < ActiveRecord::Base
  before_create :generate_code
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores non-ActiveRecord classes which contains callbacks
```ruby

class Product < BasicProduct
  before_create :generate_code
end

```
## Ducalis::CaseMapping

Try to avoid `case when` statements. You can replace it with a sequence
 of `if... elsif... elsif... else`. For cases where you need to choose
 from a large number of possibilities, you can create a dictionary
 mapping case values to functions to call by `call`. It's nice to have
 prefix for the method names, i.e.: `visit_`.
Usually `case when` statements are using for the next reasons:

I. Mapping between different values.
("A" => 1, "B" => 2, ...)

This case is all about data representing. If you do not need to execute any code
it's better to use data structure which represents it. This way you are
separating concepts: code returns corresponding value and you have config-like
data structure which describes your data.

```ruby
  %w[A B ...].index("A") + 1
  # or
  { "A" => 1, "B" => 2 }.fetch("A")
```

II. Code execution depending of parameter or type:

  - a. (:attack => attack, :defend => defend)
  - b. (Feet => value * 0.348, Meters => `value`)

In this case code violates OOP and S[O]LID principle. Code shouldn't know about
object type and classes should be open for extension, but closed for
modification (but you can't do it with case-statements).
This is a signal that you have some problems with architecture.

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

This case is combination of I and II -- high code complexity and unit-tests
complexity. There are variants how to solve it:

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

This way decreases code complexity by delegating it to lambdas and makes it easy
 to unit-testing because it's easy to test pure lambdas.

Such approach is named
[table-driven design](<https://www.d.umn.edu/~gshute/softeng/table-driven.html>)
. Table-driven methods are schemes that allow you to look up information in a
table rather than using logic statements (i.e. case, if). In simple cases,
it's quicker and easier to use logic statements, but as the logic chain becomes
more complex, table-driven code is simpler than complicated logic, easier to
modify and more efficient.
</details>

![](https://placehold.it/10/f03c15/000000?text=+) raises on case statements
```ruby

case grade
when "A"
  puts "Well done!"
when "B"
  puts "Try harder!"
when "C"
  puts "You need help!!!"
else
  puts "You just making it up!"
end

```
## Ducalis::ControllersExcept

Prefer to use `:only` over `:except` in controllers because it's more
 explicit and will be easier to maintain for new developers.

![](https://placehold.it/10/f03c15/000000?text=+) raises for `before_filters` with `except` method as array
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, except: [:index]

  def index; end
  def edit; end

  private

  def update_cost; end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for filters with many actions and only one `except` method
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, :load_me, except: %i[edit]

  def index; end
  def edit; end

  private

  def update_cost; end
  def load_me; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores `before_filters` without arguments
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost

  def index; end

  private

  def update_cost; end
end

```
## Ducalis::KeywordDefaults

Prefer to use keyword arguments for defaults. It increases readability
 and reduces ambiguities.

![](https://placehold.it/10/f03c15/000000?text=+) raises if method definition contains default values
```ruby
def calculate(step, index, dry = true); end
```

![](https://placehold.it/10/f03c15/000000?text=+) raises if class method definition contains default values
```ruby
def self.calculate(step, index, dry = true); end
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores if method definition contains default values through keywords
```ruby
def calculate(step, index, dry: true); end
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores for methods without arguments
```ruby
def calculate_amount; end
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores for class methods without arguments
```ruby
def self.calculate_amount; end
```
## Ducalis::ModuleLikeClass

Seems like it will be better to define initialize and pass %<args>s
 there instead of each method.

![](https://placehold.it/10/f03c15/000000?text=+) raises if class doesn't contain constructor but accept the same args
```ruby

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

![](https://placehold.it/10/f03c15/000000?text=+) raises for class with only one public method with args
```ruby

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

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores classes with custom includes
```ruby

class TaskJournal
  include Singleton

  def approve(task)
    # ...
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores classes with inheritance
```ruby

class TaskJournal < BasicJournal
  def approve(task)
    # ...
  end

  private

  def log(record)
    # ...
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores classes with one method and initializer
```ruby

class TaskJournal
  def initialize(task)
    # ...
  end

  def call(args)
    # ...
  end
end

```
## Ducalis::ParamsPassing

It's better to pass already preprocessed params hash to services. Or
 you can use `arcane` gem.

![](https://placehold.it/10/f03c15/000000?text=+) raises if user pass `params` as argument from controller
```ruby

class ProductsController < ApplicationController
  def index
    Record.new(params).log
  end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises if user pass `params` as any argument from controller
```ruby

class ProductsController < ApplicationController
  def index
    Record.new(first_arg, params).log
  end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises if user pass `params` as keyword argument from controller
```ruby

class ProductsController < ApplicationController
  def index
    Record.new(first_arg, any_name: params).log
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores passing only one `params` field
```ruby

class ProductsController < ApplicationController
  def index
    Record.new(first_arg, params[:id]).log
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores passing processed `params`
```ruby

class ProductsController < ApplicationController
  def index
    Record.new(first_arg, params.slice(:name)).log
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores passing `params` from `arcane` gem
```ruby

class ProductsController < ApplicationController
  def index
    Record.new(params.for(Log).as(user).refine).log
  end
end

```
## Ducalis::PossibleTap

Consider of using `.tap`, default ruby
 [method](<https://apidock.com/ruby/Object/tap>)
 which allows to replace intermediate variables with block, by this you
 are limiting scope pollution and make scope more clear.
 [Related article](<http://seejohncode.com/2012/01/02/ruby-tap-that/>).

![](https://placehold.it/10/f03c15/000000?text=+) raises for methods with scope variable return
```ruby

def load_group
  group = channel.groups.find(params[:group_id])
  authorize group, :edit?
  group
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for methods with instance variable changes and return
```ruby

def load_group
  @group = Group.find(params[:id])
  authorize @group
  @group
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for methods with instance variable `||=` assign and return
```ruby

def define_roles
  return [] unless employee

  @roles ||= []
  @roles << "primary"  if employee.primary?
  @roles << "contract" if employee.contract?
  @roles
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for methods which return call on scope variable
```ruby

def load_group
  elections = @elections.group_by(&:code)
  result = elections.map do |code, elections|
    { code => statistic }
  end
  result << total_spend(@elections)
  result.inject(:merge)
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for methods which return instance variable but have scope vars
```ruby

def generate_file(file_name)
  @file = Tempfile.new([file_name, ".pdf"])
  signed_pdf = some_new_stuff
  @file.write(signed_pdf.to_pdf)
  @file.close
  @file
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores empty methods
```ruby

def edit
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores methods which body is just call
```ruby

def total_cost(cost_field)
  Service.cost_sum(cost_field)
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores methods which return some statement
```ruby

  def stop_terminated_employee
  if current_user && current_user.terminated?
    sign_out current_user
    redirect_to new_user_session_path
  end
end


```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores calling methods on possible tap variable
```ruby

def create_message_struct(message)
  objects = message.map { |object| process(object) }
  Auditor::Message.new(message.process, objects)
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores methods which simply returns instance var without changes
```ruby

def employee
  @employee
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores methods which ends with if condition
```ruby

def complete=(value, complete_at)
  value = value.to_b
  self.complete_at = complete_at if complete && value
  self.complete_at = nil unless value
end

```
## Ducalis::PreferableMethods

Prefer to use %<alternative>s method instead of %<original>s because of
 %<reason>s.
Dangerous methods are:
`delete_all`, `delete`.

![](https://placehold.it/10/f03c15/000000?text=+) raises for `delete` method calling
```ruby
User.where(id: 7).delete
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores calling `delete` with symbol
```ruby
params.delete(:code)
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores calling `delete` with string
```ruby
string.delete("-")
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores calling `delete` with multiple args
```ruby
some.delete(1, header: [])
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores calling `delete` on files-like variables
```ruby
tempfile.delete
```
## Ducalis::PrivateInstanceAssign

Don't use filters for setting instance variables, use them only for
 changing application flow, such as redirecting if a user is not
 authenticated. Controller instance variables are forming contract
 between controller and view. Keeping instance variables defined in one
 place makes it easier to: reason, refactor and remove old views, test
 controllers and views, extract actions to new controllers, etc.
If you want to memoize variable, please, add underscore to the variable name start: `@_name`.

![](https://placehold.it/10/f03c15/000000?text=+) raises for assigning instance variables in controllers private methods
```ruby

class EmployeesController < ApplicationController
  private

  def load_employee
    @employee = Employee.find(params[:id])
  end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for memoization variables in controllers private methods
```ruby

class EmployeesController < ApplicationController
  private

  def catalog
    @catalog ||= Catalog.new
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores memoization variables in controllers private methods with _
```ruby

class EmployeesController < ApplicationController
  private

  def catalog
    @_catalog ||= Catalog.new
  end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores assigning instance variables in controllers public methods
```ruby

class EmployeesController < ApplicationController
  def index
    @employee = load_employee
  end

  private

  def load_employee
    Employee.find(params[:id])
  end
end

```
## Ducalis::ProtectedScopeCop

Seems like you are using `find` on non-protected scope. Potentially it
 could lead to unauthorized access. It's better to call `find` on
 authorized resources scopes. Example:

 ```ruby
 current_group.employees.find(params[:id])
 # better then
 Employee.find(params[:id])
 ```

![](https://placehold.it/10/f03c15/000000?text=+) raises if somewhere AR search was called on not protected scope
```ruby
Group.find(8)
```

![](https://placehold.it/10/f03c15/000000?text=+) raises if AR search was called even for chain of calls
```ruby
Group.includes(:profiles).find(8)
```

![](https://placehold.it/10/f03c15/000000?text=+) ignores where statements and still raises error
```ruby
Group.includes(:profiles).where(name: "John").find(8)
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores find method with passed block
```ruby
MAPPING.find { |x| x == 42 }
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores find method with passed multiline block
```ruby

MAPPING.find do |x|
  x == 42
end

```
## Ducalis::RaiseWithourErrorClass

It's better to add exception class as raise argument. It will make
 easier to catch and process it later.

![](https://placehold.it/10/f03c15/000000?text=+) raises when `raise` called without exception class
```ruby
raise "Something went wrong"
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores when `raise` called with exception class
```ruby
raise StandardError, "Something went wrong"
```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores when `raise` called with exception instance
```ruby
raise StandardError.new("Something went wrong")
```
## Ducalis::RegexCop

It's better to move regex to constants with example instead of direct
 using it. It will allow you to reuse this regex and provide instructions
 for others.

```ruby
CONST_NAME = %<constant>s # "%<example>s"
%<fixed_string>s
```
Available regexes are:
      `/[[:alnum:]]/`, `/[[:alpha:]]/`, `/[[:blank:]]/`, `/[[:cntrl:]]/`, `/[[:digit:]]/`, `/[[:graph:]]/`, `/[[:lower:]]/`, `/[[:print:]]/`, `/[[:punct:]]/`, `/[[:space:]]/`, `/[[:upper:]]/`, `/[[:xdigit:]]/`, `/[[:word:]]/`, `/[[:ascii:]]/`

![](https://placehold.it/10/f03c15/000000?text=+) raises if somewhere in code used regex which is not moved to const
```ruby

name = "john"
puts "hi" if name =~ /john/

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores matching constants
```ruby

REGEX = /john/
name = "john"
puts "hi" if name =~ REGEX

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores named ruby constants
```ruby

name = "john"
puts "hi" if name =~ /[[:alpha:]]/

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores dynamic regexs
```ruby

name = "john"
puts "hi" if name =~ /.{#{name.length}}/

```
## Ducalis::RestOnlyCop

It's better for controllers to stay adherent to REST:
 http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/

![](https://placehold.it/10/f03c15/000000?text=+) raises for controllers with non-REST methods
```ruby

class ProductsController < ApplicationController
  def index; end
  def recalculate; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores controllers with private non-REST methods
```ruby

class ProductsController < ApplicationController
  def index; end

  private

  def recalculate; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores controllers with only REST methods
```ruby

class ProductsController < ApplicationController
  def index; end
  def show; end
  def new; end
  def edit; end
  def create; end
  def update; end
  def destroy; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores non-controllers with non-REST methods
```ruby

class PriceStore
  def index; end
  def recalculate; end
end

```
## Ducalis::RubocopDisable

Please, do not suppress RuboCop metrics, may be you can introduce some
 refactoring or another concept.

![](https://placehold.it/10/f03c15/000000?text=+) raises on RuboCop disable comments
```ruby

# rubocop:disable Metrics/ParameterLists
def calculate(five, args, at, one, list); end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores comment without RuboCop disabling
```ruby

# some meaningful comment
def calculate(five, args, at, one, list); end

```
## Ducalis::StringsInActiverecords

Please, do not use strings as arguments for %<method_name>s argument.
 It's hard to test, grep sources, code highlighting and so on.
 Consider using of symbols or lambdas for complex expressions.

![](https://placehold.it/10/f03c15/000000?text=+) raises for string if argument
```ruby

before_save :set_full_name, 
 if: 'name_changed? || postfix_name_changed?'

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores lambda if argument
```ruby
validates :file, if: -> { remote_url.blank? }
```
## Ducalis::UncommentedGem

Please, add comment why are you including non-realized gem version for
 %<gem>s. It will increase
 [bus-factor](<https://en.wikipedia.org/wiki/Bus_factor>).

![](https://placehold.it/10/f03c15/000000?text=+) raises for gem from github without comment
```ruby

gem 'pry', '~> 0.10', '>= 0.10.0'
gem 'rake', '~> 12.1'
gem 'rspec', git: 'https://github.com/rspec/rspec'

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores for gem from github with comment
```ruby

gem 'pry', '~> 0.10', '>= 0.10.0'
gem 'rake', '~> 12.1'
gem 'rspec', github: 'rspec/rspec' # new non released API

```
## Ducalis::UselessOnly

Seems like there is no any reason to keep before filter only for one
 action. Maybe it will be better to inline it?

 ```ruby
 before_filter :do_something, only: %i[index]
 def index; end

 # to

 def index
   do_something
 end
 ```

![](https://placehold.it/10/f03c15/000000?text=+) raises for `before_filters` with only one method as array
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, only: [:index]

  def index; end

  private

  def update_cost; end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for `before_filters` with only one method as keyword array
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, only: %i[index]

  def index; end

  private

  def update_cost; end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for `before_filters` with many actions and only one method
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, :load_me, only: %i[index]

  def index; end

  private

  def update_cost; end
  def load_me; end
end

```

![](https://placehold.it/10/f03c15/000000?text=+) raises for `before_filters` with only one method as argument
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, only: :index

  def index; end

  private

  def update_cost; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores `before_filters` without arguments
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost

  def index; end

  private

  def update_cost; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores `before_filters` with `only` and many arguments
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, only: %i[index show]

  def index; end
  def show; end

  private

  def update_cost; end
end

```

![](https://placehold.it/10/2cbe4e/000000?text=+) ignores `before_filters` with `except` and one argument
```ruby

class ProductsController < ApplicationController
  before_filter :update_cost, except: %i[index]

  def index; end

  private

  def update_cost; end
end

```