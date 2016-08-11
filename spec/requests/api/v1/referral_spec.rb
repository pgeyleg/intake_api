# frozen_string_literal: true
require 'rails_helper'

describe 'Referral API' do
  describe 'POST /api/v1/referrals' do
    it 'creates a referral' do
      params = { referral: { reference: '123ABC' } }
      post '/api/v1/referrals', params

      expect(response.status).to eq(201)
      body = JSON.parse(response.body)
      expect(body['id']).to_not eq nil
      expect(body['reference']).to eq('123ABC')
    end
  end
end
