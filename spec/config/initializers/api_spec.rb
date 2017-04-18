# frozen_string_literal: true
require 'rails_helper'

describe API do
  before do
    allow(ENV).to receive(:fetch).with('SEARCH_URL')
      .and_return('http://search_api_url')
  end

  describe '.make_api_call' do
    # let(:security_token) { 'my_security_token' }

    it 'sends search requests to the API' do
      stub_request(:get, %r{/api/v1/dora/people/_search})
      API.make_api_call('/api/v1/dora/people/_search', :get)
      expect(
        a_request(:get,  %r{/api/v1/dora/people/_search})
      ).to have_been_made
    end
  end
end

