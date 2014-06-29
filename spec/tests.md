#Testing Collisterator

Our tests are written with RSpec and uses FactoryGirl. To run:

	rake spec

	rspec </path/to/_spec.rb>


Feature specs are written with Capybara, and use the [page object model]("https://robots.thoughtbot.com/better-acceptance-tests-with-page-objects) to help simplify the tests.

Pretty soon we will have Jasmine for writing the Javascript unit tests.

To add a spec that requires the Rails environment to be loaded, or uses any of the Rails helpers, make sure to remember to `require 'rails_helper'`. For lightweight specs that do not require the entire Rails environment to be loaded, `require 'spec_helper'`.

DatabaseCleaner cleans out the database after `:each`; what that means is we should avoid adding `before(:all)` in an of our specs.
