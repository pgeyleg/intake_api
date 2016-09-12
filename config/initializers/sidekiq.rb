# frozen_string_literal: true

db = Rails.env.test? ? 1 : 0
sidekiq_config = { url: "#{ENV['REDIS_URL']}/#{db}" }.freeze

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
