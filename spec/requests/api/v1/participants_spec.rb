# frozen_string_literal: true
require 'rails_helper'

describe 'Participants API' do
  let(:person) { Person.create! }
  let(:screening) { Screening.create! }
  let(:phone_number) do
    FactoryGirl.build(
      :phone_number,
      id: nil
    )
  end
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
      ],
      phone_numbers: [phone_number.as_json]
    }
  end
  context 'a participant does not already exist' do
    describe 'POST /api/v1/participants' do
      it 'creates a participant' do
        expect do
          post '/api/v1/participants', params: participant_params
        end.to change(PhoneNumber, :count).by(1)

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
          ),
          phone_numbers: array_including(
            a_hash_including(
              number: phone_number.number,
              type: phone_number.type
            )
          )
        )
        expect(body['id']).to_not eq nil
        expect(body['addresses'].first['id']).to_not eq nil
        expect(body['phone_numbers'].first['id']).to_not eq nil
      end
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

    let(:phone_number1) do
      FactoryGirl.build(:phone_number)
    end

    let(:phone_number2) do
      FactoryGirl.build(
        :phone_number,
        id: nil
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
        addresses: [address1],
        phone_numbers: [phone_number1],
        roles: ['Victim', 'Anonymous Reporter']
      )
    end
    let(:updated_first_name) { 'Marge' }
    let(:updated_last_name) { 'Simpson' }
    let(:updated_roles) { ['Victim'] }

    describe 'PUT /api/v1/participants/:id' do
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
          ],
          phone_numbers: [phone_number2.as_json],
          roles: updated_roles
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
          ),
          phone_numbers: array_including(
            a_hash_including(
              number: phone_number2.number,
              type: phone_number2.type
            )
          ),
          roles: updated_roles
        )
      end
    end

    describe 'DELETE /api/v1/participants/:id' do
      it 'deletes a participant' do
        delete "/api/v1/participants/#{participant.id}"
        expect(response.status).to eq(204)
        expect(Participant.where(person_id: person.id).size).to eq 0
      end
    end
  end

  context 'When a participant has allegations' do
    let(:screening) { Screening.create! }
    let(:jeff) do
      Participant.create(
        screening: screening,
        first_name: 'Jeff',
        last_name: 'Winger',
        roles: ['Perpetrator']
      )
    end
    let(:annie) do
      Participant.create(
        screening: screening,
        first_name: 'Annie',
        last_name: 'Sullivan',
        roles: ['Victim']
      )
    end
    before do
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: annie.id,
        victim_id: jeff.id)
    end

    describe 'PUT /api/v1/participants/:id' do
      it 'removes allegations for a participant when a role is removed' do
        expect do
          put "/api/v1/participants/#{jeff.id}", params: { roles: [] }
        end.to change(Allegation, :count).by(-1)
      end
    end

    describe 'DELETE api/v1/participants/:id' do
      it 'deletes related allegations when the participant is deleted' do
        expect do
          delete "/api/v1/participants/#{jeff.id}"
        end.to change(Allegation, :count).by(-1)
      end
    end
  end
end
