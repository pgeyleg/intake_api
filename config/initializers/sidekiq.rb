# frozen_string_literal: true

redis_url = if Rails.env.test?
              ENV['TEST_REDIS_DATABASE']
            else
              ENV['REDIS_DATABASE']
            end
sidekiq_config = { url: redis_url }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
