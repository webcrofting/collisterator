source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '~> 3.2.11'

gem 'execjs'

gem 'rack-cors', :require => 'rack/cors'

gem'figaro'

group :production do
	gem 'pg'
end


group :assets do
  gem 'sass-rails',   '>= 3.2'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
	gem "better_errors"
	gem 'sqlite3'
end

group :development, :test do
	gem 'rspec-rails'
	gem 'jasmine'
end

group :test do
	gem 'factory_girl_rails'
	gem 'capybara'
	gem 'poltergeist'
	gem 'database_cleaner', '1.0.1'
	gem 'launchy'
	gem 'rake'
end

gem 'jquery-rails'
gem 'jqtree-rails'

gem 'closure_tree'

# To use haml for the views
gem 'haml', '3.1.7'

gem "bootstrap-sass", "~> 3.0.3.0"
gem "bootstrap-x-editable-rails"
gem "font-awesome-rails"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'


gem 'devise'
gem 'cancan'

gem 'omniauth'
gem 'omniauth-google-oauth2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
 gem 'capistrano'
