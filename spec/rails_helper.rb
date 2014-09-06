ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require_relative 'support/page'

Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# LOAD SHARED EXAMPLES
Dir[Rails.root.join("spec/controllers/shared_examples/**/*.rb")].each { |f| require f }


RSpec.configure do |config|

	config.include Capybara::DSL

	config.include FactoryGirl::Syntax::Methods

	config.include Devise::TestHelpers, type: :controller

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

	config.before(:suite) do
		FactoryGirl.lint
		DatabaseCleaner.clean_with(:truncation)
	end

	config.before(:each) do
		DatabaseCleaner.strategy = :transaction
	end

	config.before(:each, :js => true) do
		DatabaseCleaner.strategy = :truncation
	end

	config.before(:each) do
		DatabaseCleaner.start
	end

	config.after(:each) do
		DatabaseCleaner.clean
	end
end
