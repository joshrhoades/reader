# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
#require 'capybara/poltergeist'
#require 'webmock/rspec'
require 'vcr'
require 'sidekiq/testing'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

VCR.configure do |config|
  config.cassette_library_dir = "#{Rails.root}/spec/support/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:window_size => [1280, 1024]})
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

RSpec.configure do |config|
  #Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :chrome
  #Capybara.javascript_driver = :poltergeist

  config.include Devise::TestHelpers, :type => :controller

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include Devise::TestHelpers, :type => :controller
  # config.extend ControllerMacros, :type => :controller
  config.include TestHelpers

  DatabaseCleaner.strategy = :truncation

  config.before :each do
    # if example.options[:poltergeist] == true || example.options[:js] == true
    #   DatabaseCleaner.start
    # else
    #   ActiveRecord::Base.connection.increment_open_transactions
    #   ActiveRecord::Base.connection.begin_db_transaction
    # end

    DatabaseCleaner.clean

    create_anon_user


    #page.driver.resize 1600, 1400 if page.driver.respond_to? :resize
  end

  config.after :each do
    # Capybara.use_default_driver
    # #config.use_transactional_fixtures = true
    # if example.options[:poltergeist] == true || example.options[:js] == true
    #   DatabaseCleaner.clean
    # else
    #   ActiveRecord::Base.connection.rollback_db_transaction
    #   ActiveRecord::Base.connection.decrement_open_transactions
    # end
  end
end
