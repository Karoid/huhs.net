source 'https://rubygems.org'
ruby "~> 2.6.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '=5.2.3'
gem 'bootsnap', require: false
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
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
gem 'loofah'
#free remote storage service
gem 'cloudinary'
#edit db in browser /rails/db
gem 'rails_db'

#:git => 'https://github.com/Karoid/rock_scissors_paper'
#:path => "../rock_scissors_paper"
#제거할 때 rails d rock_scissors_paper point
if File.exist?("../rock_scissors_paper")
  gem "rock_scissors_paper", :path => "../rock_scissors_paper"
else
  gem "rock_scissors_paper", :git => 'https://github.com/Karoid/rock_scissors_paper'
end

if File.exist?("../check_attendence")
  gem "check_attendence", :path => "../check_attendence"
else
  gem "check_attendence", :git => "https://github.com/Karoid/check_attendence.git"
end

if File.exist?("../enrollment")
  gem "enrollment", :path => "../enrollment"
end
#제거할 때 rails d irwi_wiki, rails d irwi_wiki_views
gem 'irwi', :git => 'git://github.com/alno/irwi.git'
#markdown for writing
gem 'redcarpet'
# markdown WIZIWIG editor
if File.exist?("../tui_editor-rails")
  gem "tui_editor-rails", :path => "../tui_editor-rails"
else
  gem 'tui_editor-rails', :git => "https://github.com/Karoid/tui_editor-rails.git"
end
# Service worker for speed, and webapp
gem 'serviceworker-rails'
#for webpush
gem 'webpush'

# Use ActiveModel has_secure_password
gem 'bcrypt', '>= 3.1.12'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :production do
  #gem 'pg',      :group => :production
  gem 'pg'
  #compress asset in heroku
  gem 'heroku-deflater'
end
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', git: "https://github.com/larskanis/sqlite3-ruby", branch: "add-gemspec"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  #Supporting gem for Rails Panel (Google Chrome extension for Rails development).
  gem 'meta_request'
  gem 'better_errors'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
