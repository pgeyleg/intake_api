# frozen_string_literal: true

require 'rails_helper'

describe 'Authentication Concern', type: :controller do
  controller do
    include AuthenticationConcern

    def index
      render text: 'Hello, world!', status: 200
    end
  end

  context 'when remote authentication is enabled' do
    let(:auth_url) { 'http://test.com' }
    let(:auth_token) { 'fake_token' }
    let(:http_status) { 200 }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('AUTHENTICATION_URL').and_return(auth_url)
      allow(ENV).to receive(:fetch).with('AUTHENTICATION').and_return('true')
      controller.request.headers['Authorization'] = auth_token
      faraday_double = double :faraday, status: http_status
      allow(Faraday).to receive(:get)
        .with("#{auth_url}/authn/validate?token=#{auth_token}")
        .and_return faraday_double
    end

    it 'gets part of the url from the environment variable' do
      expect(ENV).to receive(:fetch).with('AUTHENTICATION_URL').and_return(auth_url)
      get :index
    end

    it 'authenticates the request' do
      expect(controller).to receive(:authenticate_request).and_call_original
      get :index
    end

    context 'with a valid token' do
      let(:http_status) { 200 }

      it 'responds with a 200 status' do
        get :index
        expect(response.status).to eq 200
      end

      it 'hits correct action' do
        expect(controller).to receive(:index).and_call_original
        get :index
      end
    end

    context 'token is invalid' do
      let(:http_status) { 403 }

      it 'responds with a 403' do
        get :index
        expect(response.status).to eq 403
      end

      it 'responds with the correct message' do
        get :index
        expect(response.body).to eq({ errors: ['Forbidden, request not authorized'] }.to_json)
      end
    end

    context 'other errors' do
      let(:http_status) { 403 }

      it 'responds with 403 for any non-200 response' do
        get :index
        expect(response.status).to eq 403
      end
    end
  end

  context 'when remote authentication is not enabled' do
    before do
      allow(ENV).to receive(:fetch).with('AUTHENTICATION').and_return('false')
    end

    it 'should skip authenticate request' do
      expect(controller).to_not receive(:authenticate_request).and_call_original
      get :index
    end
  end
end
