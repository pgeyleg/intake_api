# frozen_string_literal: true

TPT.connection = Faraday.new(url: Rails.configuration.intake_api[:search_url]) do |connection|
  connection.response :json, content_type: /\bjson$/
  connection.response :logger, ::Logger.new(STDOUT), bodies: true
  connection.adapter Faraday.default_adapter
  connection
end
