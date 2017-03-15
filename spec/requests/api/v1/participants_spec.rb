# frozen_string_literal: true
require 'rails_helper'

describe 'Participants API' do
  describe 'POST /api/v1/participants' do
    let(:person) { Person.create! }
    let(:screening) { Screening.create! }
    let(:participant_params) do
      {
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
    end
    context 'a participant does not already exist' do
      it 'creates a participant' do
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
        expect(body['addresses'].first['id']).to_not eq nil
      end
    end

    context 'participant already exists' do
      let(:address1) do
        Address.new(
          street_address: '123 fake st',
          city: 'Fake City',
          state: 'NY',
          zip: '10010',
          type: 'Placement'
        )
      end

      let(:participant) do
        Participant.create!(
          person_id: person.id,
          screening_id: screening.id,
          first_name: 'Walter',
          last_name: 'White',
          gender: 'female',
          date_of_birth: '1990-03-30',
          ssn: '345-12-2345',
          addresses: [address1]
        )
      end
      let(:updated_first_name) { 'Marge' }
      let(:updated_last_name) { 'Simpson' }

      it 'gets a paticipant' do
        get "/api/v1/participants/#{participant.id}"
        expect(response.status).to eq(200)

        body = JSON.parse(response.body).with_indifferent_access
        expect(body).to include(
          first_name: 'Walter'
        )
      end

      it 'updates a participant' do
        updated_params = {
          first_name: updated_first_name,
          last_name: updated_last_name,
          addresses: [
            {
              street_address: '321 real st',
              city: 'Real City',
              state: 'NY',
              zip: '10010',
              type: 'Placement'
            }
          ]
        }

        put "/api/v1/participants/#{participant.id}", params: updated_params

        expect(response.status).to eq(200)
        body = JSON.parse(response.body).with_indifferent_access
        expect(body).to include(
          first_name: updated_first_name,
          last_name: updated_last_name,
          addresses: array_including(
            a_hash_including(
              street_address: '321 real st',
              state: 'NY',
              city: 'Real City',
              zip: '10010',
              type: 'Placement'
            )
          )
        )
      end

      it 'deletes a participant' do
        delete "/api/v1/participants/#{participant.id}"
        expect(response.status).to eq(204)
        expect(Participant.where(person_id: person.id).size).to eq 0
      end
    end
  end
end
