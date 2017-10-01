# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'policial', github: 'volmer/policial'
gem 'regexp-examples'
gem 'thor'
gem 'git'

group :test, :development do
  gem 'pry'
  gem 'rspec'
end

group :production do
  gem 'puma'
  gem 'sinatra'
end
