# frozen_string_literal: true

# API module which will define abstracts the API connection
# The connection object will be used to talk to the API
module API
  CONTENT_TYPE = 'application/json'

  def self.connection_settings(connection)
    connection.response :json, content_type: /\bjson$/
    connection.adapter Faraday.default_adapter
    connection
  end

  def self.people_search_connection(path)
    @connection ||= Faraday.new(url: ENV.fetch('ELASTICSEARCH_URL')+path) do |connection|
      ::API.connection_settings connection
    end
  end

  def self.make_api_call(url, method, payload = nil)
    people_search_connection(url).send(method) do |req|
      req.url url
      req.headers['Content-Type'] = CONTENT_TYPE unless method == :get
      req.body = payload.to_json unless payload.nil?
    end
  # rescue Faraday::Error => e
    # raise ApiError,
      # message: e.message,
      # sent_attributes: payload.to_json,
      # url: url, method: method
  end
end
