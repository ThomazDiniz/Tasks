source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'rails', '~> 7.0.0'
gem 'puma', '~> 5.0'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'rack-cors'
gem 'pg', '~> 1.4'
gem 'sqlite3', '~> 1.4', group: :development

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '~> 3.3'
end

