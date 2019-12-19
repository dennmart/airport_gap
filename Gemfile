source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2.1'
gem 'pg', '~> 1.1.4'
gem 'puma', '~> 4.3'
gem 'webpacker', '~> 4.2'
gem 'jbuilder', '~> 2.7'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'fast_jsonapi', '~> 1.5'
gem 'will_paginate', '~> 3.2'
gem 'haversine', '~> 0.3'
gem 'rack-attack', '~> 6.2'
gem 'sidekiq', '~> 6.0'
gem 'rouge', '~> 3.13'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.9'
  gem 'factory_bot_rails', '~> 5.1'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 4.1'
  gem 'faker', '~> 2.9'
end
