ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'mongoid'
require 'database_cleaner-mongoid'
require 'simplecov'

SimpleCov.start

# Load application
require_relative '../config/environment'

# Load factories
Dir[File.join(__dir__, 'factories', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:deletion)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  def app
    Parking::API::Base
  end
end
