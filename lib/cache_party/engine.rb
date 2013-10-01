
#
# 3rd party libraries
require 'celluloid'
require 'celluloid/autostart'
require 'exception_notification'
require 'koala'
require 'open-uri'
require 'sucker_punch'

# local libraries
require_relative 'facebook/helpers'

module CacheParty
  class Engine < ::Rails::Engine

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( cache_party/application.js cache_party/application.css )
    end

    isolate_namespace CacheParty
    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true,
        fixtures: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories/cache_party'
      g.helper = false
      g.stylesheets = false
    end 


  end
end
