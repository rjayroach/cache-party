source "http://rubygems.org"

# Declare your gem's dependencies in cache_party.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
#gem "omniauth-facebook"


# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
#
gem "mcp_common", :path => "/home/maxpub/dev/engines/mcp_common"
gem "mcp_auth", :path => "/home/maxpub/dev/engines/mcp_auth"

gem "thin"
gem "mysql2"
gem "quiet_assets", :group => :development
group :assets do
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
  gem "jquery-ui-rails"
  gem "therubyracer", :platform => :ruby
end

group :test do
  gem "timecop"
  gem "spork"
  gem "guard-spork"
  gem "guard-rspec"
  gem "rb-inotify"
  gem "simplecov"
  gem "capybara"
  gem "poltergeist"
  gem "database_cleaner"
  gem "faker"
end

gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "shoulda-matchers", :group => [:development, :test]
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "rails3-generators", :group => :development
gem "pry"
gem "pry-rails"
gem "pry-doc", :group => [:development, :test]
gem "pry-nav", :group => [:development, :test]
gem "pry-stack_explorer", :group => [:development, :test]
