source 'https://rubygems.org'

# ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Utilize the TVDB API from Ruby to fetch shows, track updates to the tvdb and sync your media database
# gem 'tvdbr'

# gem 'program-tv'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'oj'
gem 'thread', require: 'thread/pool'
gem 'concurrent-ruby'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# authentications
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'simple_token_authentication', '~> 1.0'

gem 'immutable-struct'
gem 'puma'
gem 'rails_12factor', group: :production
gem 'slim-rails'

gem 'httparty'
gem 'tpdata', require: 'theplatform'

gem 'font-awesome-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sweet-alert-confirm'

gem "administrate"
gem "administrate-field-image"

gem 'carrierwave-aws'

gem 'kaminari'

gem 'stripe'

gem 'gon'

gem 'language_list'

gem 'mini_magick'
gem 'active_model_serializers', '~> 0.10.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-sweetalert'
end

group :development, :test do
  gem 'pry'
  gem 'byebug'
  gem 'quiet_assets'
  gem 'dotenv-rails'
  gem 'guard-foreman', require: false
  gem 'guard-rspec', require: false
  gem 'rspec-rails'
  gem 'faker'
  gem 'terminal-notifier-guard', '~> 1.6.1'
  gem 'rubocop', require: false
  gem 'guard-rubocop'
end

group :test do
  gem 'factory_girl_rails'
  gem 'vcr'
  gem 'webmock'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'open_uri_redirections'
