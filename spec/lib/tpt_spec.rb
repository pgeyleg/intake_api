# frozen_string_literal: true

require 'rails_helper'

describe TPT do
  let(:security_token) { FFaker::Guid.guid }
  around do |example|
    original_connection = TPT.connection
    TPT.connection = Faraday.new(url: 'http://api_url')
    example.run
    TPT.connection = original_connection
  end

  describe '.make_api_call' do
    it 'sends search requests to the TPT' do
      stub_request(:get, %r{/api/v1/dora/people/_search})
      TPT.make_api_call(security_token, '/api/v1/dora/people/_search', :get)
      expect(
        a_request(:get, %r{/api/v1/dora/people/_search})
      ).to have_been_made
      expect(
        a_request(:get, %r{/api/v1/dora/people/_search})
        .with(headers: { 'Content-Type' => 'application/json' })
      ).not_to have_been_made
    end

    it 'includes Authorization header' do
      stub_request(:get, %r{/api/v1/dora/people/_search})
      TPT.make_api_call(security_token, '/api/v1/dora/people/_search', :get)
      expect(
        a_request(:get, %r{/api/v1/dora/people/_search})
          .with(headers: { 'Authorization' => security_token })
      ).to have_been_made
    end

    it 'includes CONTENT_TYPE unless a get' do
      stub_request(:post, %r{/api/v1/dora/people/_search})
      TPT.make_api_call(security_token, '/api/v1/dora/people/_search', :post)
      expect(
        a_request(:post, %r{/api/v1/dora/people/_search})
        .with(headers: { 'Content-Type' => 'application/json' })
      ).to have_been_made
    end

    it 'includes the specified payload' do
      stub_request(:post, %r{/api/v1/dora/people/_search})
      TPT.make_api_call(security_token, '/api/v1/dora/people/_search', :post, {})
      expect(
        a_request(:post, %r{/api/v1/dora/people/_search})
        .with(body: {})
      ).to have_been_made
    end
  end
end
