# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'git'
gem 'policial', github: 'volmer/policial'
gem 'regexp-examples'
gem 'thor'

group :test, :development do
  gem 'pry'
  gem 'rspec'
end

group :production do
  gem 'puma'
  gem 'sinatra'
end
