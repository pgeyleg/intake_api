# frozen_string_literal: true
require 'rails_helper'

describe 'Participants API' do
  describe 'POST /api/v1/participants' do
    it 'creates a participant' do
      participant_params = {
        person_id: nil,
        screening_id: nil,
        first_name: 'Walter',
        last_name: 'White',
        gender: 'female',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345'
      }

      post '/api/v1/participants', params: participant_params

      expect(response.status).to eq(201)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to include(
        person_id: nil,
        screening_id: nil,
        first_name: 'Walter',
        last_name: 'White',
        gender: 'female',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345'
      )
      expect(body['id']).to_not eq nil
    end
  end
end
