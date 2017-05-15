# frozen_string_literal: true

# API module which will define abstracts the API connection
# The connection object will be used to talk to the API
module API
  CONTENT_TYPE = 'application/json'

  def self.connection_settings(connection)
    connection.response :json, content_type: /\bjson$/
    connection.response :logger, ::Logger.new(STDOUT), bodies: true
    connection.adapter Faraday.default_adapter
    connection
  end

  def self.tpt_connection
    @connection ||= Faraday.new(url: ENV.fetch('SEARCH_URL', 'http://tptsearch')) do |connection|
      ::API.connection_settings connection
    end
  end

  def self.make_api_call(security_token, url, method, payload = nil)
    tpt_connection.send(method) do |req|
      req.url url
      req.headers['Content-Type'] = CONTENT_TYPE unless method == :get
      req.headers['Authorization'] = security_token
      req.body = payload.to_json unless payload.nil?
    end
  end
end
