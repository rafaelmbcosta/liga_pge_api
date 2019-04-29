#ruby '2.3.4'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'redis'
gem 'resque'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use mysql as the database for Active Record
gem 'pg'
gem 'rack', '~> 2.0.6'
gem "loofah", '>= 2.2.3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'knock'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'nokogiri', '1.8.5'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'sinatra', '2.0.2'
# manage env variable
gem "figaro"
gem 'sprockets', '3.7.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'gemsurance'
  # Rspec for rails 5
  gem 'rspec-rails', '~> 3.6'
  gem 'rubocop-performance'
  # mocking objects and classes
  gem 'mocha'

  # Mock rails models
  gem 'factory_bot_rails'
  gem 'rubocop-rspec', '1.27.0'
  # Fake attributes for factories
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
