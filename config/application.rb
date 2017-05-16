# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CasebookApi
  class Application < Rails::Application # :nodoc:
    # Settings in config/environments/* take precedence over those
    # specified here. Application configuration should go into files
    # in config/initializers -- all .rb files in that directory are
    # automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.autoload_paths << Rails.root.join('app/indexers')
    config.autoload_paths << Rails.root.join('app/search_repos')
    config.api_only = true
    config.active_record.schema_format = :sql
    config.logger = Logger.new(STDOUT)
    config.log_level = :debug

    config.intake_api = {
      people_search_path: ENV.fetch('PEOPLE_SEARCH_PATH', '/api/v1/dora/people/_search'),
      search_url: ENV.fetch('SEARCH_URL', 'http://tptsearch')
    }
  end
end
