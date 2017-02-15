# frozen_string_literal: true
require 'rails_helper'

describe 'Participants API' do
  describe 'POST /api/v1/participants' do
    it 'creates a participant' do
      person = Person.create!
      screening = Screening.create!
      participant_params = {
        person_id: person.id,
        screening_id: screening.id,
        first_name: 'Walter',
        last_name: 'White',
        gender: 'female',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345',
        addresses: [
          {
            street_address: '123 fake st',
            city: 'Fake City',
            state: 'NY',
            zip: '10010',
            type: 'Placement'
          },
          {
            street_address: '711 capital Mall',
            city: 'Sacramento',
            state: 'CA',
            zip: '95822',
            type: 'Home'
          }
        ]
      }

      post '/api/v1/participants', params: participant_params

      expect(response.status).to eq(201)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to include(
        person_id: person.id,
        screening_id: screening.id,
        first_name: 'Walter',
        last_name: 'White',
        gender: 'female',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345',
        addresses: array_including(
          a_hash_including(
            street_address: '123 fake st',
            state: 'NY',
            city: 'Fake City',
            zip: '10010',
            type: 'Placement'
          ),
          a_hash_including(
            street_address: '711 capital Mall',
            city: 'Sacramento',
            state: 'CA',
            zip: '95822',
            type: 'Home'
          )
        )
      )
      expect(body['id']).to_not eq nil
    end
  end
end
