source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
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
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
#members login gem
gem 'devise'
# 권한설정
gem 'cancancan'
#board page moving method!
gem 'will_paginate', '~> 3.1.0'
#comments gem
gem 'acts_as_commentable_with_threading'
#Parsing an HTML / XML Document
gem 'nokogiri'
#XSS Attack defence
gem 'loofah', :git => 'https://github.com/flavorjones/loofah.git'
#free remote storage service
gem 'cloudinary'
#edit db in browser /rails/db
gem 'rails_db'

#:git => 'https://github.com/Karoid/rock_scissors_paper'
#:path => "../rock_scissors_paper"
#제거할 때 rails d rock_scissors_paper point
gem "rock_scissors_paper", :git => 'https://github.com/Karoid/rock_scissors_paper'

if File.exist?("../check_attendence")
  gem "check_attendence", :path => "../check_attendence"
else
  gem "check_attendence", :git => "https://github.com/Karoid/check_attendence.git"
end
#제거할 때 rails d irwi_wiki, rails d irwi_wiki_views
gem 'irwi', :git => 'git://github.com/alno/irwi.git'
#markdown for writing
gem 'redcarpet'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :production do
  #gem 'pg',      :group => :production
  gem 'pg'
end
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  #Supporting gem for Rails Panel (Google Chrome extension for Rails development).
  gem 'meta_request'
  gem 'better_errors'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
