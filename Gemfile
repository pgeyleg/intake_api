# frozen_string_literal: true

source 'https://rubygems.org'

gem 'active_model_serializers'
gem 'elasticsearch-persistence'
gem 'faraday'
gem 'faraday_middleware'
gem 'newrelic_rpm'
gem 'paper_trail'
gem 'pg', '~> 0.18'
gem 'puma', '3.6.2'
gem 'rack-cors'
gem 'rails', '~> 5.1'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'pry-theme'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'timecop'
  gem 'fpm'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'ci_reporter_rspec'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
