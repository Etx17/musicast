source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
gem 'faraday'
gem 'nokogiri'
gem 'devise_invitable', '~> 2.0.0'
gem 'cloudinary'
gem "breadcrumbs_on_rails"
gem 'friendly_id', '~> 5.4.0'
gem 'money-rails', '~> 1.12'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
gem "country_select"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
gem 'rqrcode'
gem 'wicked_pdf'

gem "countries"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"
gem 'stripe'
gem 'stripe_event'

# Storage with AWS S3
gem "aws-sdk-s3"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false



# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"
gem 'pdf-reader'
gem "ruby-openai"
gem "pundit"
gem "bootstrap", "~> 5.2"
gem "devise"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"
gem 'rubyzip'
gem "wicked"

group :production do
  gem 'wkhtmltopdf-heroku', '~> 2.12.6'
end

group :development, :test do
  gem 'wkhtmltopdf-binary'
  gem "dotenv-rails"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'annotate'
  gem 'faker'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'stripe-ruby-mock', '~> 3.1.0', :require => 'stripe_mock'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "letter_opener"
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'activerecord-explain-analyze'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "noticed", "~> 2.4"

gem "view_component", "~> 3.13"

gem 'i18n-debug'
gem 'rails-i18n', '~> 8.0.0'

# Gestion des images et métadonnées
gem 'mini_magick'

gem 'kaminari'
