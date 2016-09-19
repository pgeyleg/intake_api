# frozen_string_literal: true

db = Rails.env.test? ? 1 : 0
redis_url = if Rails.env.test?
              ENV['TEST_REDIS_DATABASE']
            else
              ENV['REDIS_DATABASE']
            end
sidekiq_config = { url: redis_url }.freeze

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
