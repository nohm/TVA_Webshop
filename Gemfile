# encoding: utf-8
source 'https://rubygems.org'
ruby '2.3.0'

# Rails base
gem 'rails', '~> 4.2.0'
gem 'turbolinks'
gem 'nprogress-rails'
# Deployment
gem 'mina'
# Database
gem 'pg'
# Logs
gem 'lograge'
# CSS
gem 'sass-rails' # , '4.0.2'
gem 'bootstrap-sass', '~> 3.3.0'
# Javascript
gem 'coffee-rails'
gem 'jquery-rails'
gem 'modernizr-rails'
# Assets
gem 'uglifier'
gem 'jbuilder'
# Protection
gem 'cancancan'
gem 'devise'
gem 'figaro'
gem 'rolify'
# Attachments
gem 'paperclip'
# Better forms
gem 'bootstrap_form'
# Barcodes
gem 'barby'
gem 'has_barcode'
# Zip files
gem 'rubyzip'
# Pagination
gem 'kaminari'
# Async worker
gem 'sucker_punch'
# Cron scheduler
gem 'whenever', require: false
# Error reporting
gem 'exception_notification'
# Maps
gem 'leaflet-rails'
# Markdown rendering
gem 'redcarpet'
# PDF rendering
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
# Timestamps
gem 'rails-timeago', '~> 2.0'
# Ignoring weekends
gem 'business_time'
# Ignoring holidays
gem 'holidays'
# Encrypt password
gem 'bcrypt',        '3.1.7'
# Breadcrumbs
gem "gretel"
# Rake
gem 'rake', '11.0.1'

gem 'country_select'

group :assets do
  # Javascript engine
  gem 'therubyracer', platform: :ruby
end

group :development do
  # Server
  gem 'puma'
  gem 'foreman'
  # Error handling
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  # Mail catcher
  gem 'letter_opener'
  # UML Diagrams
  gem 'railroady'
  # Querying
  gem 'bullet'
  gem 'lol_dba'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.1.0'
end

group :test do
  gem 'capybara-webkit', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
  gem 'webmock'
  gem 'minitest-reporters', '1.0.5'
end
