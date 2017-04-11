# frozen_string_literal: true
require 'rails_helper'

describe 'Participants Phone Numbers API' do
  describe 'PUT /api/v1/participants/:id' do
    it 'adds an phone number if one did not exist before' do
      participant = FactoryGirl.create(
        :participant
      )
      updated_params = {
        phone_numbers: [{
          number: '916-555-1212',
          type: 'Work'
        }]
      }

      expect do
        put "/api/v1/participants/#{participant.id}", params: updated_params
      end.to change(PhoneNumber, :count).by(1)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        phone_numbers: array_including(
          a_hash_including(
            :id,
            number: '916-555-1212',
            type: 'Work'
          )
        )
      )
    end

    it 'does nothing if an existing phone number has not changed' do
      phone_number = FactoryGirl.create(:phone_number)
      participant = FactoryGirl.create(
        :participant,
        first_name: 'Bart',
        phone_numbers: [phone_number]
      )

      updated_params = {
        first_name: 'Fred',
        phone_numbers: [phone_number.as_json]
      }

      expect do
        put "/api/v1/participants/#{participant.id}", params: updated_params
      end.to change(PhoneNumber, :count).by(0)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        first_name: 'Fred',
        phone_numbers: array_including(
          a_hash_including(
            number: phone_number.number,
            type: phone_number.type
          )
        )
      )
    end

    it 'deletes phone numbers that have been removed from the set' do
      participant = FactoryGirl.create(
        :participant,
        phone_numbers: [
          FactoryGirl.create(:phone_number)
        ]
      )

      updated_params = {
        first_name: 'Fred',
        phone_numbers: []
      }

      expect do
        put "/api/v1/participants/#{participant.id}", params: updated_params
      end.to change(PhoneNumber, :count).by(-1)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        id: participant.id,
        first_name: 'Fred',
        phone_numbers: []
      )
    end
  end
end
