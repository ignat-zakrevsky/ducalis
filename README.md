# Ducalis

[![Gem Version](https://badge.fury.io/rb/ducalis.svg)](https://badge.fury.io/rb/ducalis)
[![Build Status](https://travis-ci.org/ignat-z/ducalis.svg?branch=master)](https://travis-ci.org/ignat-z/ducalis)
[![Maintainability](https://api.codeclimate.com/v1/badges/d03d4e567e8728d2c58b/maintainability)](https://codeclimate.com/github/ignat-z/ducalis/maintainability)

__Ducalis__ is RuboCop-based static code analyzer for enterprise Rails applications.

Documentation available at https://ducalis-rb.github.io/. Changelog at https://ducalis-rb.github.io/log.

__Ducalis__ isn't style checker and could sometimes be false-positive it's not
necessary to follow all it rules, the main purpose of __Ducalis__ is help to find
possible weak code parts.

## Installation and Usage

Add this line to your application's `Gemfile`:

```ruby
gem 'ducalis'
```

__Ducalis__ is CLI application. By defaukt it will notify you about any possible
 violations in CLI.

```
ducalis .
ducalis app/controllers/
```

__Ducalis__ allows to pass build even with violations it's make sense to run
__Ducalis__ across current branch or index:

```
ducalis --branch .
ducalis --index .
```

Additionally you can pass `--reporter` argument to notify about found violations
 in boundaries of PR:

```
ducalis --reporter "author/repo#42" .
ducalis --reporter "circleci" .
```

_N.B._ You should provide `GITHUB_TOKEN` Env to allow __Ducalis__ download your
PR code and write review comments.

In CLI modes you can provide yours `.ducalis.yml` file based on
[default](https://github.com/ignat-z/ducalis/blob/master/config/.ducalis.yml) by
`-c` flag or simply putting it in your project directory.

## Configuration

One or more individual cops can be disabled locally in a section of a file by adding a comment such as

```ruby
# ducalis:disable Ducalis/PreferableMethods Use `delete_all` because of performance reasons
def remove_audits
  AuditLog.where(user_id: user_id).delete_all
end
```

The main behavior of Ducalis can be controlled via the
[.ducalis.yml](<https://github.com/ignat-z/ducalis/blob/master/config/.ducalis.yml>).
It makes it possible to enable/disable certain cops (checks) and to alter their
behavior if they accept any parameters. List of all available cops could be
found in the [documentation](<https://ducalis-rb.github.io/>).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contribution

Contributions are welcome! To pass your code through the all checks you simply need to run:

```
bundle exec rake
```
