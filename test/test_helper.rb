ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('integration_helper.rb', File.dirname(__FILE__))
require 'rails/test_help'
require 'capybara/rails'
require 'minitest/autorun'

ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
end
# FactoryGirl.create :season
