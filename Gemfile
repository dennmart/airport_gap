source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '4.0.1'

gem 'rails', '8.1.2'
gem 'pg', '~> 1.6.2'
gem 'puma', '~> 7.2.0'
gem 'jbuilder', '~> 2.14.1'
gem 'bcrypt', '~> 3.1.21'
gem 'bootsnap', '~> 1.21.1', require: false
gem 'csv', '~> 3.3.5', require: false
gem 'jsonapi-serializer', '~> 2.2.0'
gem 'will_paginate', '~> 4.0.1'
gem 'haversine', '~> 0.3'
gem 'rack-attack', '~> 6.8'

# Sidekiq 8.1.0+ forces connection_pool to '~> 3', which is incompatible with Rails 8.1 and the Redis cache store.
# Locking sidekiq and connection_pool gems until Rails is updated.
gem 'sidekiq', '8.0.10'
gem 'connection_pool', '~> 2.5.5'

gem 'rouge', '~> 4.7.0'
gem 'rack-cors', '~> 3.0.0'
gem 'turbo-rails', '~> 2.0.23'
gem 'jsbundling-rails', '~> 1.3.1'
gem 'sprockets-rails', '~> 3.5.2'
gem 'rubocop', '~> 1.84', require: false
gem 'rubocop-rails', '~> 2.34', require: false
gem 'rubocop-rspec', '~> 3.9', require: false
gem 'rubocop-rspec_rails', '~> 2.32', require: false
gem 'rubocop-performance', '~> 1.26', require: false
gem 'rubocop-factory_bot', '~> 2.28', require: false
gem 'redis', '~> 5.4.1'
gem 'kamal', '~> 2.10.1'
gem 'thruster', '~> 0.1.17'
gem 'tailwindcss-ruby', '~> 4.1.18'
gem 'tailwindcss-rails', '~> 4.4.0'

group :development, :test do
  gem 'debug', '~> 1.11.0', require: 'debug/prelude'
  gem 'rspec-rails', '~> 8.0.2'
  gem 'factory_bot_rails', '~> 6.5.1'
  gem 'brakeman', '~> 8.0.1', require: false
end

group :development do
  gem 'web-console'
  gem 'listen'
end

group :test do
  gem 'shoulda-matchers', '~> 7.0.1'
  gem 'faker', '~> 3.6.0'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'webmock', '~> 3.26.1'
end
