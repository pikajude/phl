ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('integration_helper.rb', File.dirname(__FILE__))
require 'rails/test_help'
require 'capybara/rails'
require 'minitest/autorun'

class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods

  def teardown
    DatabaseCleaner.clean
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end

DatabaseCleaner.strategy = :truncation
