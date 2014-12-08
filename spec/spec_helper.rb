require 'rubygems'
require 'rspec'
require 'database_cleaner'

require_relative '../alice'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.orm = "mongoid"
#    DatabaseCleaner.strategy = :truncation
 #   DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end

Mongoid::Config.connect_to("mongoid_test")
