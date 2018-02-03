# Ducalis

[![Gem Version](https://badge.fury.io/rb/ducalis.svg)](https://badge.fury.io/rb/ducalis)
[![Build Status](https://travis-ci.org/ignat-z/ducalis.svg?branch=master)](https://travis-ci.org/ignat-z/ducalis)
[![Maintainability](https://api.codeclimate.com/v1/badges/d03d4e567e8728d2c58b/maintainability)](https://codeclimate.com/github/ignat-z/ducalis/maintainability)

__Ducalis__ is RuboCop-based static code analyzer for enterprise Rails applications.
As __Ducalis__ isn't style checker and could sometimes be false-positive it's not
necessary to follow all it rules, the main purpose of __Ducalis__ is help to find
possible weak code parts.

[Documentation](<https://ducalis-rb.github.io/>)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ducalis'
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Usage

There are a lot of variants how you can use __Ducalis__:

1. As CLI application. In this mode __Ducalis__ will notify you about any
possible violations in CLI.
```
ducalis
ducalis app/controllers/
```
As __Ducalis__ allows to pass build even with violations it's make sense to run
__Ducalis__ across current branch or index:
```
ducalis --branch
ducalis --index
```

2. As CLI application in CI mode: In this mode __Ducalis__ will notify you about
any violations in your PR.
```
ducalis --ci --repo="author/repo" --id=3575 --dry
ducalis --ci --repo="author/repo" --id=3575
ducalis --ci --adapter=circle # mode for running on CircleCI
```
`--dry` option declares that output will be printed in console, if you will run
without this option __Ducalis__ will notify about violations in your PR.
_N.B._ You should provide GITHUB_TOKEN Env to allow __Ducalis__ download your PR
code and write review comments.

3. As stand-alone server mode: In this mode __Ducalis__ will work as server,
listen webhooks from GitHub, and notify about any violations in PR. There is a
`Dockerfile` which you could use to run server for this or run it manually like
rack application. All related files are located in the `client/` directory.

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

## Contribution

To pass your code through the all checks you simply need to run:

```
bundle exec rake
```
