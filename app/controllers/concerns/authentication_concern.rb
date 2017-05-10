# frozen_string_literal: true

require 'active_support/concern'

module AuthenticationConcern # :nodoc:
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request, unless: -> { ENV.fetch('AUTHENTICATION') == 'false' }

    private

    def authenticate_request
      token = request.headers['Authorization']
      response = Faraday.get("#{ENV.fetch('AUTHENTICATION_URL')}/authn/validate?token=#{token}")
      return if response.status == 200
      render json: { errors: ['Forbidden, request not authorized'] }, status: 403
    end
  end
end
