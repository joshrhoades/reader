source 'https://rubygems.org'

gem "nokogiri"
gem 'rails', '~> 3.2'
gem 'unicorn', '~> 4.4'
#gem 'puma'
gem 'god', '~> 0.13'

gem 'sidekiq', '~> 2.5'
gem 'sidekiq-failures'
# required for sidekiq web
gem 'sinatra', '~> 1.3', :require => false
gem 'slim', '~> 1.3', :require => false
gem 'thin', '~> 1.5', :require => false

gem 'pg', '~> 0.14'

gem 'omniauth', '~> 1.1'
gem 'omniauth-facebook', '~> 1.4'
gem 'devise', '~> 2.1'
gem 'acts_as_follower', '~> 0.1'
gem 'fb_graph', '~> 2.5.7'

gem 'feeder', :path => 'feeder'
gem 'feedzirra', :path => 'vendor/feedzirra'
gem 'muck-feedbag', :path => 'vendor/feedbag'
gem 'hpricot', '~> 0.8'
gem 'private_pub', '~> 1.0'
gem 'libxml-ruby', '~> 2.3'
gem 'curb', '~> 0.8'
gem 'faraday'
gem 'faraday_middleware'

gem 'embedly'

gem 'haml', '~> 3.1'
gem 'jbuilder', '~> 0.8'
gem 'oj'


gem 'loofah', '~> 1.2.1'
gem 'ensure-encoding'
gem 'pismo', '~> 0.7'
gem 'carrierwave', '~> 0.7'

gem 'pry-rails', '~> 0.2'
gem 'pry-nav', '~> 0.2'
gem 'awesome_print'

group :production do
  gem 'newrelic_rpm', '~> 3.5'
end

group :development do
  gem 'erb2haml', '~> 0.1'
  gem 'mails_viewer', '~> 0.0'
  gem 'capistrano', '~> 2.13'
  gem 'rvm-capistrano', '~> 1.2'
  gem 'foreman', '~> 0.60'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.11'
  gem 'quiet_assets', '~> 1.0'
  gem 'jasmine-rails'
end

group :test do
  gem 'database_cleaner', '~> 0.9'
  gem 'capybara', '~> 1.0'
  gem 'vcr', '~> 2.3'
  gem 'webmock', '~> 1.8'
  gem 'launchy'
end

group :assets do
  gem 'jquery-rails', '~> 2.1'
  gem 'sass-rails', '~> 3.2'
  gem 'bootstrap-sass', '~> 2.2.1.1'
  gem 'coffee-rails', '~> 3.2'
  gem 'compass-rails', '~> 1.0'
  gem 'handlebars_assets', '~> 0.6'
  gem 'uglifier', '~> 1.3'
  gem 'turbo-sprockets-rails3', '~> 0.2'
end
