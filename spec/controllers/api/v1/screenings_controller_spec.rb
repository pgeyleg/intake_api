# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ScreeningsController do
  it { is_expected.to use_before_action :authenticate_request }

  describe '#submit' do
    let(:screening_id) { '9' }
    before do
      service = double(:create_referral)
      allow(CreateReferral).to receive(:new).and_return(service)
      allow(service).to receive(:call)
        .with(screening_id: screening_id, security_token: nil)
        .and_return(service_response)
    end
    let(:service_response) do
      double(:response, status: response_status, body: response_body)
    end

    context 'when successfully created a referral' do
      let(:created_referral_id) { '22' }
      let(:response_status) { 201 }
      let(:response_body) do
        { 'legacy_id' => created_referral_id }
      end

      it 'returns the referral id' do
        post :submit, params: { id: screening_id }
        expect(response.status).to eq service_response.status
        expect(response.body).to eq({ referral_id: created_referral_id }.to_json)
      end
    end

    context 'when failed to create a referral' do
      let(:response_status) { 422 }
      let(:response_body) do
        { error: 'Errors listed' }
      end

      it 'returns the response body and status' do
        post :submit, params: { id: screening_id }
        expect(response.status).to eq service_response.status
        expect(response.body).to eq(response_body.to_json)
      end
    end
  end
end
