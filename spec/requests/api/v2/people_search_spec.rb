# frozen_string_literal: true

require 'rails_helper'

describe 'People Search API', skip_auth: true do
  describe 'GET /api/v2/people_search' do
    let(:auth_token) { FFaker::Guid.guid }

    around do |example|
      config = Rails.configuration.intake_api
      Rails.configuration.intake_api[:people_search_path] = '/people_search_path'
      example.run
      Rails.configuration.intake_api = config
    end

    it 'passes the Authorization header to people search API' do
      response_body = { hits: { hits: [] } }.to_json
      stub_request(:post, %r{/people_search_path})
        .and_return(body: response_body, headers: { 'Content-Type' => 'json' })

      get api_v2_people_search_index_path(search_term: 'Test'),
        headers: { Authorization: auth_token }
      expect(
        a_request(:post, %r{/people_search_path})
        .with(headers: { Authorization: auth_token })
      ).to have_been_made
    end
  end
end
