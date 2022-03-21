source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

gem 'rails', '~> 7.0.2.3'
gem 'pg', '~> 1.3.4'
gem 'puma', '~> 5.6'
gem 'webpacker', '~> 5.4.0'
gem 'jbuilder', '~> 2.11.2'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'fast_jsonapi', '~> 1.5'
gem 'will_paginate', '~> 3.3'
gem 'haversine', '~> 0.3'
gem 'rack-attack', '~> 6.2'
gem 'sidekiq', '~> 6.4'
gem 'rouge', '~> 3.13'
gem 'rack-cors', '~> 1.1.1'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 5.1.1'
  gem 'factory_bot_rails', '~> 6.2.0'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  # Temporarily disabling since this gem doesn't have support for the latest
  # spring gem which is required for Rails 7.
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 5.1'
  gem 'faker', '~> 2.20'
end
