# frozen_string_literal: true

require 'rails_helper'

describe API do
  before do
    allow(ENV).to receive(:fetch).with('SEARCH_URL')
      .and_return('http://search_api_url')
  end

  describe '.make_api_call' do
    it 'sends search requests to the API' do
      stub_request(:get, %r{/api/v1/dora/people/_search})
      API.make_api_call('/api/v1/dora/people/_search', :get)
      expect(
        a_request(:get, %r{/api/v1/dora/people/_search})
      ).to have_been_made
      expect(
        a_request(:get, %r{/api/v1/dora/people/_search})
        .with(headers: { 'Content-Type' => 'application/json' })
      ).not_to have_been_made
    end

    it 'includes CONTENT_TYPE unless a get' do
      stub_request(:post, %r{/api/v1/dora/people/_search})
      API.make_api_call('/api/v1/dora/people/_search', :post)
      expect(
        a_request(:post, %r{/api/v1/dora/people/_search})
        .with(headers: { 'Content-Type' => 'application/json' })
      ).to have_been_made
    end

    it 'includes the specified payload' do
      stub_request(:post, %r{/api/v1/dora/people/_search})
      API.make_api_call('/api/v1/dora/people/_search', :post, {})
      expect(
        a_request(:post, %r{/api/v1/dora/people/_search})
        .with(body: {})
      ).to have_been_made
    end
  end
end
