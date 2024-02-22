source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Pretty print your Ruby objects with style -- in full color and with proper indentation
gem "awesome_print", "~> 1.9" 

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.8'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'rspec', '~> 3.13'

  gem "rspec-expectations", "~> 3.13"
  gem "rspec-instafail", "~> 1.0"
  gem "rspec-rails", "~> 6.1"

  gem "database_cleaner", "~> 2.0"
  gem "shoulda-callback-matchers", "~> 1.1"
  gem "shoulda-matchers", "~> 6.1"

  gem "pry", "~> 0.14.2"
end

group :development do
  gem 'web-console'

  gem 'rubocop', '~> 1.60'
  gem 'rubocop-rails', '~> 2.23'
  gem 'rubocop-rspec', '~> 2.26'

  gem "bundler-audit", "~> 0.9.1"
end

