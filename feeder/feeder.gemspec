$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "feeder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "feeder"
  s.version     = Feeder::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Feeder."
  s.description = "TODO: Description of Feeder."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "sidekiq"
  s.add_dependency "faraday"
  s.add_dependency "faraday_middleware"
  s.add_dependency 'ensure-encoding'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  # s.add_development_dependency "guard-rspec"
  # s.add_development_dependency "guard-spork"
end
